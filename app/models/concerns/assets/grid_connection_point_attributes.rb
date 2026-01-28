module Assets
  module GridConnectionPointAttributes
    def connection_capacity
      (attributes_data || {})["connectionCapacity"]
    end

    def active_power
      (attributes_data || {})["activePower"]
    end

    def reactive_power
      (attributes_data || {})["reactivePower"]
    end

    def voltage
      (attributes_data || {})["voltage"]
    end

    def frequency
      (attributes_data || {})["frequency"]
    end

    def energy_exported
      (attributes_data || {})["energyExported"]
    end

    def energy_imported
      (attributes_data || {})["energyImported"]
    end

    def connection_status
      (attributes_data || {})["connectionStatus"]
    end

    def location
      (attributes_data || {})["location"]
    end
  end
end
