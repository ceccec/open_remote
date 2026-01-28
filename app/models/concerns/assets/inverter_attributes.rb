module Assets
  module InverterAttributes
    def inverter_capacity
      (attributes_data || {})["inverterCapacity"]
    end

    def ac_power_output
      (attributes_data || {})["acPowerOutput"]
    end

    def dc_power_input
      (attributes_data || {})["dcPowerInput"]
    end

    def ac_voltage
      (attributes_data || {})["acVoltage"]
    end

    def ac_frequency
      (attributes_data || {})["acFrequency"]
    end

    def efficiency
      (attributes_data || {})["efficiency"]
    end

    def temperature
      (attributes_data || {})["temperature"]
    end

    def uptime
      (attributes_data || {})["uptime"]
    end

    def status
      (attributes_data || {})["status"]
    end

    def alarm_status
      (attributes_data || {})["alarmStatus"]
    end
  end
end
