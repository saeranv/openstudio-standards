
# Extend the class to add Medium Office specific stuff
class OpenStudio::Model::Model
 
  def define_space_type_map(building_type, building_vintage, climate_zone)
    space_type_map = {
      # 'Basement', 'ER_Exam1_Mult4_Flr_1', 'ER_Trauma1_Flr_1', 'ER_Exam3_Mult4_Flr_1', 'ER_Trauma2_Flr_1', 'ER_Triage_Mult4_Flr_1', 'Office1_Mult4_Flr_1', 'Lobby_Records_Flr_1', 'Corridor_Flr_1', 'ER_NurseStn_Lobby_Flr_1', 'OR1_Flr_2', 'OR2_Mult5_Flr_2', 'OR3_Flr_2', 'OR4_Flr_2', 'IC_PatRoom1_Mult5_Flr_2', 'IC_PatRoom2_Flr_2', 'IC_PatRoom3_Mult6_Flr_2', 'ICU_Flr_2', 'ICU_NurseStn_Lobby_Flr_2', 'Corridor_Flr_2', 'OR_NurseStn_Lobby_Flr_2', 'PatRoom1_Mult10_Flr_3', 'PatRoom2_Flr_3', 'PatRoom3_Mult10_Flr_3', 'PatRoom4_Flr_3', 'PatRoom5_Mult10_Flr_3', 'PhysTherapy_Flr_3', 'PatRoom6_Flr_3', 'PatRoom7_Mult10_Flr_3', 'PatRoom8_Flr_3', 'NurseStn_Lobby_Flr_3', 'Lab_Flr_3', 'Corridor_SE_Flr_3', 'Corridor_NW_Flr_3', 'PatRoom1_Mult10_Flr_4', 'PatRoom2_Flr_4', 'PatRoom3_Mult10_Flr_4', 'PatRoom4_Flr_4', 'PatRoom5_Mult10_Flr_4', 'Radiology_Flr_4', 'PatRoom6_Flr_4', 'PatRoom7_Mult10_Flr_4', 'PatRoom8_Flr_4', 'NurseStn_Lobby_Flr_4', 'Lab_Flr_4', 'Corridor_SE_Flr_4', 'Corridor_NW_Flr_4', 'Dining_Flr_5', 'NurseStn_Lobby_Flr_5', 'Kitchen_Flr_5', 'Office1_Flr_5', 'Office2_Mult5_Flr_5', 'Office3_Flr_5', 'Office4_Mult6_Flr_5', 'Corridor_Flr_5'
      'Corridor' => ['Corridor_Flr_1', 'Corridor_Flr_2', 'Corridor_SE_Flr_3', 'Corridor_NW_Flr_3', 'Corridor_SE_Flr_4', 'Corridor_NW_Flr_4', 'Corridor_Flr_5'],
      'Dining' => ['Dining_Flr_5', ],
      'ER_Exam' => ['ER_Exam1_Mult4_Flr_1', 'ER_Exam3_Mult4_Flr_1', ],
      'ER_NurseStn' => ['ER_NurseStn_Lobby_Flr_1', ],
      'ER_Trauma' => ['ER_Trauma1_Flr_1', 'ER_Trauma2_Flr_1', ],
      'ER_Triage' => ['ER_Triage_Mult4_Flr_1', ],
      'ICU_NurseStn' => ['ICU_NurseStn_Lobby_Flr_2', ],
      'ICU_Open' => ['ICU_Flr_2', ],
      'ICU_PatRm' => ['IC_PatRoom1_Mult5_Flr_2', 'IC_PatRoom2_Flr_2', 'IC_PatRoom3_Mult6_Flr_2', ],
      'Kitchen' => ['Kitchen_Flr_5', ],
      'Lab' => ['Lab_Flr_3', 'Lab_Flr_4', ],
      'Lobby' => ['Lobby_Records_Flr_1', ],
      'NurseStn' => ['OR_NurseStn_Lobby_Flr_2', 'NurseStn_Lobby_Flr_3', 'NurseStn_Lobby_Flr_4', 'NurseStn_Lobby_Flr_5', ],
      'OR' => ['OR1_Flr_2', 'OR2_Mult5_Flr_2', 'OR3_Flr_2', 'OR4_Flr_2', ],
      'Office' => ['Office1_Mult4_Flr_1', 'Office1_Flr_5', 'Office2_Mult5_Flr_5', 'Office3_Flr_5', 'Office4_Mult6_Flr_5', 'Basement', ], # I don't know where to put Basement
      # 'PatCorridor' => [],
      'PatRoom' => ['PatRoom1_Mult10_Flr_3', 'PatRoom2_Flr_3', 'PatRoom3_Mult10_Flr_3', 'PatRoom4_Flr_3', 'PatRoom5_Mult10_Flr_3', 'PatRoom6_Flr_3', 
        'PatRoom7_Mult10_Flr_3', 'PatRoom8_Flr_3', 'PatRoom1_Mult10_Flr_4', 'PatRoom2_Flr_4', 'PatRoom3_Mult10_Flr_4', 'PatRoom4_Flr_4', 'PatRoom5_Mult10_Flr_4', 
        'PatRoom6_Flr_4', 'PatRoom7_Mult10_Flr_4', 'PatRoom8_Flr_4', ],
      'PhysTherapy' => ['PhysTherapy_Flr_3', ],
      'Radiology' => ['Radiology_Flr_4', ]  # total number of zones: 55 - equals to the IDF
    }
    return space_type_map
  end

  def define_hvac_system_map(building_type, building_vintage, climate_zone)
    system_to_space_map = [
      {
          'type' => 'VAV',
          'space_names' => [
            'Basement', 'Office1_Mult4_Flr_1', 'Lobby_Records_Flr_1', 'Corridor_Flr_1', 'ER_NurseStn_Lobby_Flr_1', 
            'ICU_NurseStn_Lobby_Flr_2', 'Corridor_Flr_2', 'OR_NurseStn_Lobby_Flr_2'
          ]
      },
      {
          'type' => 'VAV',
          'space_names' => [
            'ER_Exam1_Mult4_Flr_1', 'ER_Trauma1_Flr_1', 'ER_Exam3_Mult4_Flr_1', 'ER_Trauma2_Flr_1', 'ER_Triage_Mult4_Flr_1'
          ]
      },
      {
          'type' => 'VAV',
          'space_names' => [
            'OR1_Flr_2', 'OR2_Mult5_Flr_2', 'OR3_Flr_2', 'OR4_Flr_2'
          ]
      },
      {
          'type' => 'VAV',
          'space_names' => [
            'IC_PatRoom1_Mult5_Flr_2', 'IC_PatRoom2_Flr_2', 'IC_PatRoom3_Mult6_Flr_2', 'ICU_Flr_2'
          ]
      },
      {
          'type' => 'VAV',
          'space_names' => [
            'PatRoom1_Mult10_Flr_3', 'PatRoom2_Flr_3', 'PatRoom3_Mult10_Flr_3', 'PatRoom4_Flr_3', 'PatRoom5_Mult10_Flr_3', 'PatRoom6_Flr_3', 
            'PatRoom7_Mult10_Flr_3', 'PatRoom8_Flr_3', 'PatRoom1_Mult10_Flr_4', 'PatRoom2_Flr_4', 'PatRoom3_Mult10_Flr_4', 'PatRoom4_Flr_4', 
            'PatRoom5_Mult10_Flr_4', 'PatRoom6_Flr_4', 'PatRoom7_Mult10_Flr_4', 'PatRoom8_Flr_4'
          ]
      },
      {
          'type' => 'VAV',
          'space_names' => [
            'PhysTherapy_Flr_3', 'NurseStn_Lobby_Flr_3', 'Corridor_SE_Flr_3', 'Corridor_NW_Flr_3', 'Radiology_Flr_4', 
            'NurseStn_Lobby_Flr_4', 'Corridor_SE_Flr_4', 'Corridor_NW_Flr_4', 'Dining_Flr_5', 'NurseStn_Lobby_Flr_5', 
            'Office1_Flr_5', 'Office2_Mult5_Flr_5', 'Office3_Flr_5', 'Office4_Mult6_Flr_5', 'Corridor_Flr_5'
          ]
      },
      {
          'type' => 'VAV',
          'space_names' => [
            'Lab_Flr_3', 'Lab_Flr_4'
          ]
      },
      {
          'type' => 'CAV',
          'space_names' => [
            'Kitchen_Flr_5'
          ]                     # 55 spaces assigned.
      },
	  {
            'type' => 'Refrigeration',
            'case_type' => 'Walkin Freezer',
            'cooling_capacity_per_length' => 734,
            'length' => 10.98,
            'evaporator_fan_pwr_per_length' => 69,
            'lighting_per_length' => 33,
            'lighting_sch_name' => 'Hospital BLDG_LIGHT_SCH',
            'defrost_pwr_per_length' => 364,
            'restocking_sch_name' => 'Hospital Kitchen_Flr_5_Case:1_WALKINFREEZER_WalkInStockingSched',
            'cop' => 1.5,
            'cop_f_of_t_curve_name' => 'RACK1_RackCOPfTCurve',
            'condenser_fan_pwr' => 1000,
            'condenser_fan_pwr_curve_name' => 'RACK1_RackCondFanCurve2',
            'space_names' =>
            [
                'Kitchen_Flr_5'
            ]
        },
	  {
            'type' => 'Refrigeration',
            'case_type' => 'Display Case',
            'cooling_capacity_per_length' => 886.5,
            'length' => 8.93,
            'evaporator_fan_pwr_per_length' => 67,
            'lighting_per_length' => 40,
            'lighting_sch_name' => 'Hospital BLDG_LIGHT_SCH',
            'defrost_pwr_per_length' => 0.0,
            'restocking_sch_name' => 'Hospital Kitchen_Flr_5_Case:2_SELFCONTAINEDDISPLAYCASE_CaseStockingSched',
            'cop' => 3.0,
            'cop_f_of_t_curve_name' => 'RACK2_RackCOPfTCurve',
            'condenser_fan_pwr' => 1000,
            'condenser_fan_pwr_curve_name' => 'RACK1_RackCondFanCurve2',
            'space_names' =>
            [
                'Kitchen_Flr_5'
            ]
        }
    ]
    return system_to_space_map
  end
    
  def define_space_multiplier
    # This map define the multipliers for spaces with multipliers not equals to 1
    space_multiplier_map = {
      'ER_Exam1_Mult4_Flr_1' => 4,
      'ER_Exam3_Mult4_Flr_1' => 4,
      'ER_Triage_Mult4_Flr_1' => 4,
      'Office1_Mult4_Flr_1' => 5,
      'OR2_Mult5_Flr_2' => 5,
      'IC_PatRoom1_Mult5_Flr_2' => 5,
      'IC_PatRoom3_Mult6_Flr_2' => 6,
	  'PatRoom1_Mult10_Flr_3' => 10,
	  'PatRoom3_Mult10_Flr_3' => 10,
	  'PatRoom5_Mult10_Flr_3' => 10, 
	  'PatRoom7_Mult10_Flr_3' => 10,
	  'PatRoom1_Mult10_Flr_4' => 10,
	  'PatRoom3_Mult10_Flr_4' => 10,
	  'PatRoom5_Mult10_Flr_4' => 10,
	  'PatRoom7_Mult10_Flr_4' => 10,
	  'Office2_Mult5_Flr_5' => 5,
	  'Office4_Mult6_Flr_5' => 6
    }
    return space_multiplier_map
  end
    
  def add_hvac(building_type, building_vintage, climate_zone, prototype_input, hvac_standards)
   
    OpenStudio::logFree(OpenStudio::Info, 'openstudio.model.Model', 'Started Adding HVAC')
    
    system_to_space_map = define_hvac_system_map(building_type, building_vintage, climate_zone)

    condenser_water_loop = self.add_cw_loop(prototype_input, hvac_standards)
	
	chilled_water_loop = self.add_chw_loop(prototype_input, hvac_standards, condenser_water_loop)

    hot_water_loop = self.add_hw_loop(prototype_input, hvac_standards)
    
    system_to_space_map.each do |system|

      #find all zones associated with these spaces
      thermal_zones = []
      system['space_names'].each do |space_name|
        space = self.getSpaceByName(space_name)
        if space.empty?
          OpenStudio::logFree(OpenStudio::Error, 'openstudio.model.Model', "No space called #{space_name} was found in the model")
          return false
        end
        space = space.get
        zone = space.thermalZone
        if zone.empty?
          OpenStudio::logFree(OpenStudio::Error, 'openstudio.model.Model', "No thermal zone was created for the space called #{space_name}")
          return false
        end
        thermal_zones << zone.get
      end

      case system['type']
      when 'VAV'
        self.add_vav(prototype_input, hvac_standards, system['name'], hot_water_loop, chilled_water_loop, thermal_zones, building_type)
      when 'CAV'
        self.add_psz_ac(prototype_input, hvac_standards, system ['name'], thermal_zones, 'DrawThrough', hot_water_loop, chilled_water_loop)
      when 'Refrigeration'
        self.add_refrigeration(prototype_input,
                              standards,
                              system['case_type'],
                              system['cooling_capacity_per_length'],
                              system['length'],
                              system['evaporator_fan_pwr_per_length'],
                              system['lighting_per_length'],
                              system['lighting_sch_name'],
                              system['defrost_pwr_per_length'],
                              system['restocking_sch_name'],
                              system['cop'],
                              system['cop_f_of_t_curve_name'],
                              system['condenser_fan_pwr'],
                              system['condenser_fan_pwr_curve_name'],
                              thermal_zones[0])
	   else
        OpenStudio::logFree(OpenStudio::Error, 'openstudio.model.Model', "Undefined HVAC system type called #{system['type']}")
        return false  
      end
	  
	end
  
    OpenStudio::logFree(OpenStudio::Info, 'openstudio.model.Model', 'Finished adding HVAC')
    
    return true
    
  end #add hvac

  def add_swh(building_type, building_vintage, climate_zone, prototype_input, hvac_standards, space_type_map)
   
    OpenStudio::logFree(OpenStudio::Info, "openstudio.model.Model", "Started Adding SWH")

    main_swh_loop = self.add_swh_loop(prototype_input, hvac_standards, 'main')
    water_heaters = main_swh_loop.supplyComponents(OpenStudio::Model::WaterHeaterMixed::iddObjectType)
    
    water_heaters.each do |water_heater|
      water_heater = water_heater.to_WaterHeaterMixed.get
      # water_heater.setAmbientTemperatureIndicator('Zone')
      # water_heater.setAmbientTemperatureThermalZone(default_water_heater_ambient_temp_sch)
      water_heater.setOffCycleParasiticFuelConsumptionRate(720)
      water_heater.setOnCycleParasiticFuelConsumptionRate(720)
      water_heater.setOffCycleLossCoefficienttoAmbientTemperature(7.561562668)
      water_heater.setOnCycleLossCoefficienttoAmbientTemperature(7.561562668)
    end

    self.add_swh_end_uses(prototype_input, hvac_standards, main_swh_loop, 'main')
    
    OpenStudio::logFree(OpenStudio::Info, "openstudio.model.Model", "Finished adding SWH")
    
    return true
    
  end #add swh    

end
