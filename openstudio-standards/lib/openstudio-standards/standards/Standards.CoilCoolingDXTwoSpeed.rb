
# Reopen the OpenStudio class to add methods to apply standards to this object
class OpenStudio::Model::CoilCoolingDXTwoSpeed
  include CoilDX

  # Finds capacity in W
  #
  # @return [Double] capacity in W to be used for find object
  def find_capacity
    capacity_w = nil
    if ratedHighSpeedTotalCoolingCapacity.is_initialized
      capacity_w = ratedHighSpeedTotalCoolingCapacity.get
    elsif autosizedRatedHighSpeedTotalCoolingCapacity.is_initialized
      capacity_w = autosizedRatedHighSpeedTotalCoolingCapacity.get
    else
      OpenStudio::logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXSingleSpeed', "For #{self.name} capacity is not available, cannot apply efficiency standard.")
      return 0.0
    end

    return capacity_w
  end

  # Finds lookup object in standards and return efficiency
  #
  # @param template [String] valid choices: 'DOE Ref Pre-1980', 'DOE Ref 1980-2004', '90.1-2004', '90.1-2007', '90.1-2010', '90.1-2013'
  # @param standards [Hash] the OpenStudio_Standards spreadsheet in hash format
  # @return [Double] full load efficiency (COP)
  def standard_minimum_cop(template, rename=false)
    search_criteria = find_search_criteria(template)
    cooling_type = search_criteria['cooling_type']
    heating_type = search_criteria['heating_type']
    sub_category = search_criteria['subcategory']
    capacity_w = find_capacity
    capacity_btu_per_hr = OpenStudio.convert(capacity_w, 'W', 'Btu/hr').get
    capacity_kbtu_per_hr = OpenStudio.convert(capacity_w, 'W', 'kBtu/hr').get

    # Lookup efficiencies depending on whether it is a unitary AC or a heat pump
    ac_props = nil
    ac_props = if heat_pump?
                 model.find_object($os_standards['heat_pumps'], search_criteria, capacity_btu_per_hr, Date.today)
               else
                 model.find_object($os_standards['unitary_acs'], search_criteria, capacity_btu_per_hr, Date.today)
               end

    # Check to make sure properties were found
    if ac_props.nil?
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find efficiency info, cannot apply efficiency standard.")
      successfully_set_all_properties = false
      return successfully_set_all_properties
    end

    # Get the minimum efficiency standards
    cop = nil

    # Check to make sure properties were found
    if ac_props.nil?
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find efficiency info, cannot apply efficiency standard.")
      return cop # value of nil
    end

    # If specified as SEER
    unless ac_props['minimum_seasonal_energy_efficiency_ratio'].nil?
      min_seer = ac_props['minimum_seasonal_energy_efficiency_ratio']
      cop = seer_to_cop_cooling_no_fan(min_seer)
      new_comp_name = "#{name} #{capacity_kbtu_per_hr.round}kBtu/hr #{min_seer}SEER"
      OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.CoilCoolingDXSingleSpeed', "For #{template}: #{name}: #{cooling_type} #{heating_type} #{sub_category} Capacity = #{capacity_kbtu_per_hr.round}kBtu/hr; SEER = #{min_seer}")
    end

    # If specified as EER
    unless ac_props['minimum_energy_efficiency_ratio'].nil?
      min_eer = ac_props['minimum_energy_efficiency_ratio']
      cop = eer_to_cop(min_eer, OpenStudio.convert(capacity_kbtu_per_hr, 'kBtu/hr', 'W').get)
      new_comp_name = "#{name} #{capacity_kbtu_per_hr.round}kBtu/hr #{min_eer}EER"
      OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.CoilCoolingDXSingleSpeed', "For #{template}: #{name}: #{cooling_type} #{heating_type} #{sub_category} Capacity = #{capacity_kbtu_per_hr.round}kBtu/hr; EER = #{min_eer}")
    end

    # if specified as SEER (heat pump)
    unless ac_props['minimum_seasonal_efficiency'].nil?
      min_seer = ac_props['minimum_seasonal_efficiency']
      cop = seer_to_cop_cooling_no_fan(min_seer)
      new_comp_name = "#{name} #{capacity_kbtu_per_hr.round}kBtu/hr #{min_seer}SEER"
      OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.CoilCoolingDXSingleSpeed', "For #{template}: #{name}: #{cooling_type} #{heating_type} #{sub_category} Capacity = #{capacity_kbtu_per_hr.round}kBtu/hr; SEER = #{min_seer}")
    end

    # If specified as EER (heat pump)
    unless ac_props['minimum_full_load_efficiency'].nil?
      min_eer = ac_props['minimum_full_load_efficiency']
      cop = eer_to_cop(min_eer, OpenStudio.convert(capacity_kbtu_per_hr, 'kBtu/hr', 'W').get)
      new_comp_name = "#{name} #{capacity_kbtu_per_hr.round}kBtu/hr #{min_eer}EER"
      OpenStudio.logFree(OpenStudio::Info, 'openstudio.standards.CoilCoolingDXSingleSpeed', "For #{template}: #{name}: #{cooling_type} #{heating_type} #{sub_category} Capacity = #{capacity_kbtu_per_hr.round}kBtu/hr; EER = #{min_eer}")
    end

    # Rename
    if rename
      setName(new_comp_name)
    end

    return cop
  end

  # Applies the standard efficiency ratings and typical performance curves to this object.
  #
  # @param template [String] valid choices: 'DOE Ref Pre-1980', 'DOE Ref 1980-2004', '90.1-2004', '90.1-2007', '90.1-2010', '90.1-2013'
  # @param standards [Hash] the OpenStudio_Standards spreadsheet in hash format
  # @return [Bool] true if successful, false if not
  def apply_efficiency_and_curves(template, sql_db_vars_map)
    successfully_set_all_properties = true

    # Get the search criteria
    search_criteria = find_search_criteria(template)

    # Get the capacity
    capacity_w = find_capacity
    capacity_btu_per_hr = OpenStudio.convert(capacity_w, 'W', 'Btu/hr').get
    capacity_kbtu_per_hr = OpenStudio.convert(capacity_w, 'W', 'kBtu/hr').get

    # Lookup efficiencies depending on whether it is a unitary AC or a heat pump
    ac_props = nil
    ac_props = if heat_pump?
                 model.find_object($os_standards['heat_pumps'], search_criteria, capacity_btu_per_hr, Date.today)
               else
                 model.find_object($os_standards['unitary_acs'], search_criteria, capacity_btu_per_hr, Date.today)
               end

    # Check to make sure properties were found
    if ac_props.nil?
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find efficiency info, cannot apply efficiency standard.")
      successfully_set_all_properties = false
      return sql_db_vars_map
    end

    # Make the total COOL-CAP-FT curve
    tot_cool_cap_ft = model.add_curve(ac_props['cool_cap_ft'])
    if tot_cool_cap_ft
      setTotalCoolingCapacityFunctionOfTemperatureCurve(tot_cool_cap_ft)
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find cool_cap_ft curve, will not be set.")
      successfully_set_all_properties = false
    end

    # Make the total COOL-CAP-FFLOW curve
    tot_cool_cap_fflow = model.add_curve(ac_props['cool_cap_fflow'])
    if tot_cool_cap_fflow
      setTotalCoolingCapacityFunctionOfFlowFractionCurve(tot_cool_cap_fflow)
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find cool_cap_fflow curve, will not be set.")
      successfully_set_all_properties = false
    end

    # Make the COOL-EIR-FT curve
    cool_eir_ft = model.add_curve(ac_props['cool_eir_ft'])
    if cool_eir_ft
      setEnergyInputRatioFunctionOfTemperatureCurve(cool_eir_ft)
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find cool_eir_ft curve, will not be set.")
      successfully_set_all_properties = false
    end

    # Make the COOL-EIR-FFLOW curve
    cool_eir_fflow = model.add_curve(ac_props['cool_eir_fflow'])
    if cool_eir_fflow
      setEnergyInputRatioFunctionOfFlowFractionCurve(cool_eir_fflow)
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find cool_eir_fflow curve, will not be set.")
      successfully_set_all_properties = false
    end

    # Make the COOL-PLF-FPLR curve
    cool_plf_fplr = model.add_curve(ac_props['cool_plf_fplr'])
    if cool_plf_fplr
      setPartLoadFractionCorrelationCurve(cool_plf_fplr)
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find cool_plf_fplr curve, will not be set.")
      successfully_set_all_properties = false
    end

    # Make the low speed COOL-CAP-FT curve
    low_speed_cool_cap_ft = model.add_curve(ac_props['cool_cap_ft'])
    if low_speed_cool_cap_ft
      setLowSpeedTotalCoolingCapacityFunctionOfTemperatureCurve(low_speed_cool_cap_ft)
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find cool_cap_ft curve, will not be set.")
      successfully_set_all_properties = false
    end

    # Make the low speed COOL-EIR-FT curve
    low_speed_cool_eir_ft = model.add_curve(ac_props['cool_eir_ft'])
    if low_speed_cool_eir_ft
      setLowSpeedEnergyInputRatioFunctionOfTemperatureCurve(low_speed_cool_eir_ft)
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXTwoSpeed', "For #{name}, cannot find cool_eir_ft curve, will not be set.")
      successfully_set_all_properties = false
    end

    # Preserve the original name
    orig_name = name.to_s

    # Find the minimum COP and rename with efficiency rating
    cop = standard_minimum_cop(template, true)

    # Map the original name to the new name
    sql_db_vars_map[name.to_s] = orig_name

    # Set the efficiency values
    unless cop.nil?
      setRatedHighSpeedCOP(cop)
      setRatedLowSpeedCOP(cop)
    end

    return sql_db_vars_map
  end
end
