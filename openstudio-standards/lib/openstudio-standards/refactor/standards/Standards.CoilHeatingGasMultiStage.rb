
# open the class to add methods to return sizing values
class StandardsModel < OpenStudio::Model::Model
  def coil_heating_gas_multi_stage_apply_efficiency_and_curves(coil_heating_gas_multi_stage, standards)
    successfully_set_all_properties = true

    # Get the coil capacity
    capacity_w = nil
    htg_stages = stages
    if htg_stages.last.nominalCapacity.is_initialized
      capacity_w = htg_stages.last.nominalCapacity.get
    elsif autosizedStage4NominalCapacity.is_initialized
      capacity_w = autosizedStage4NominalCapacity.get
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilCoolingDXMultiSpeed', "For #{coil_heating_gas_multi_stage.name} capacity is not available, cannot apply efficiency standard.")
      successfully_set_all_properties = false
      return successfully_set_all_properties
    end

    # plf vs plr curve for furnace
    furnace_plffplr_curve = model_add_curve(model, furnace_plffplr_curve_name, standards)
    if furnace_plffplr_curve
      setPartLoadFractionCorrelationCurve(furnace_plffplr_curve)
    else
      OpenStudio.logFree(OpenStudio::Warn, 'openstudio.standards.CoilHeatingGasMultiStage', "For #{coil_heating_gas_multi_stage.name}, cannot find plffplr curve, will not be set.")
      successfully_set_all_properties = false
    end
  end
end
