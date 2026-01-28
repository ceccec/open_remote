module Assets
  module EnergyMeterAttributes
    def active_power
      (attributes_data || {})["activePower"]
    end

    def reactive_power
      (attributes_data || {})["reactivePower"]
    end

    def apparent_power
      (attributes_data || {})["apparentPower"]
    end

    def energy_import
      (attributes_data || {})["energyImport"]
    end

    def energy_export
      (attributes_data || {})["energyExport"]
    end

    def voltage
      (attributes_data || {})["voltage"]
    end

    def current
      (attributes_data || {})["current"]
    end

    def power_factor
      (attributes_data || {})["powerFactor"]
    end

    def frequency
      (attributes_data || {})["frequency"]
    end
  end
end
