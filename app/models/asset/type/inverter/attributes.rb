##
# Attribute accessors for Inverter asset type.
#
# Provides convenient accessor methods for Inverter-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "Inverter" via
# the Type::Dispatch concern.
#
# @example Accessing Inverter attributes
#   inverter = Asset.find_by(name: "Inverter 1")
#   inverter.ac_power_output    # => value from attributes_data["acPowerOutput"]
#   inverter.dc_power_input     # => value from attributes_data["dcPowerInput"]
#   inverter.efficiency         # => value from attributes_data["efficiency"]
#
class Asset
  module Type
    module Inverter
      module Attributes
        ##
        # Get the inverter capacity in watts.
        #
        # @return [Numeric, nil] capacity from attributes_data["inverterCapacity"]
        def inverter_capacity
          (attributes_data || {})["inverterCapacity"]
        end

        ##
        # Get the AC power output in watts.
        #
        # @return [Numeric, nil] AC output from attributes_data["acPowerOutput"]
        def ac_power_output
          (attributes_data || {})["acPowerOutput"]
        end

        ##
        # Get the DC power input in watts.
        #
        # @return [Numeric, nil] DC input from attributes_data["dcPowerInput"]
        def dc_power_input
          (attributes_data || {})["dcPowerInput"]
        end

        ##
        # Get the AC voltage in volts.
        #
        # @return [Numeric, nil] voltage from attributes_data["acVoltage"]
        def ac_voltage
          (attributes_data || {})["acVoltage"]
        end

        ##
        # Get the AC frequency in hertz.
        #
        # @return [Numeric, nil] frequency from attributes_data["acFrequency"]
        def ac_frequency
          (attributes_data || {})["acFrequency"]
        end

        ##
        # Get the conversion efficiency as a decimal (0.0 to 1.0).
        #
        # @return [Numeric, nil] efficiency from attributes_data["efficiency"]
        def efficiency
          (attributes_data || {})["efficiency"]
        end

        ##
        # Get the current temperature in Celsius.
        #
        # @return [Numeric, nil] temperature from attributes_data["temperature"]
        def temperature
          (attributes_data || {})["temperature"]
        end

        ##
        # Get the uptime in seconds.
        #
        # @return [Integer, nil] uptime from attributes_data["uptime"]
        def uptime
          (attributes_data || {})["uptime"]
        end

        ##
        # Get the operational status (e.g., "active", "maintenance").
        #
        # @return [String, nil] status from attributes_data["status"]
        def status
          (attributes_data || {})["status"]
        end

        ##
        # Get the alarm status (e.g., "normal", "warning", "critical").
        #
        # @return [String, nil] alarm status from attributes_data["alarmStatus"]
        def alarm_status
          (attributes_data || {})["alarmStatus"]
        end
      end
    end
  end
end
