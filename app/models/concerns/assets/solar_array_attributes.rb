module Assets
  module SolarArrayAttributes
    def array_capacity
      (attributes_data || {})["arrayCapacity"]
    end

    def power_output
      (attributes_data || {})["powerOutput"]
    end

    def dc_voltage
      (attributes_data || {})["voltage"]
    end

    def dc_current
      (attributes_data || {})["current"]
    end

    def panel_count
      (attributes_data || {})["panelCount"]
    end

    def panel_orientation
      (attributes_data || {})["panelOrientation"]
    end

    def panel_tilt
      (attributes_data || {})["panelTilt"]
    end

    def temperature
      (attributes_data || {})["temperature"]
    end

    def status
      (attributes_data || {})["status"]
    end

    def location
      (attributes_data || {})["location"]
    end
  end
end
