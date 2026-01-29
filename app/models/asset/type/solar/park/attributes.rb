##
# Attribute accessors for SolarPark asset type.
#
# Provides convenient accessor methods for SolarPark-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "SolarPark" via
# the Type::Dispatch concern.
#
# @example Accessing SolarPark attributes
#   park = Asset.find_by(name: "Solar Park 1")
#   park.total_capacity        # => value from attributes_data["totalCapacity"]
#   park.total_power_output    # => value from attributes_data["totalPowerOutput"]
#   park.update_performance_ratio! # Calculate and save performance ratio
#
class Asset
  module Type
    module Solar
      module Park
        module Attributes
          ##
          # Get the total installed capacity in watts.
          #
          # @return [Numeric, nil] capacity value from attributes_data["totalCapacity"]
          def total_capacity
            (attributes_data || {})["totalCapacity"]
          end

          ##
          # Get the current total power output in watts.
          #
          # @return [Numeric, nil] power output from attributes_data["totalPowerOutput"]
          def total_power_output
            (attributes_data || {})["totalPowerOutput"]
          end

          ##
          # Get the total energy generated since installation in watt-hours.
          #
          # @return [Numeric, nil] energy from attributes_data["totalEnergyGenerated"]
          def total_energy_generated
            (attributes_data || {})["totalEnergyGenerated"]
          end

          ##
          # Get the daily energy generated in watt-hours.
          #
          # @return [Numeric, nil] daily energy from attributes_data["dailyEnergyGenerated"]
          def daily_energy_generated
            (attributes_data || {})["dailyEnergyGenerated"]
          end

          ##
          # Get the forecasted energy generation in watt-hours.
          #
          # @return [Numeric, nil] forecast from attributes_data["forecastedGeneration"]
          def forecasted_generation
            (attributes_data || {})["forecastedGeneration"]
          end

          ##
          # Get the performance ratio (actual output / capacity).
          #
          # @return [Numeric, nil] ratio from attributes_data["performanceRatio"] (0.0 to 1.0)
          def performance_ratio
            (attributes_data || {})["performanceRatio"]
          end

          ##
          # Get the geographic location.
          #
          # @return [String, Hash, nil] location from attributes_data["location"]
          def location
            (attributes_data || {})["location"]
          end

          ##
          # Calculate and update the performance ratio based on current power output.
          #
          # Performance ratio is calculated as: total_power_output / total_capacity
          # Returns a decimal value between 0.0 and 1.0 (e.g., 0.75 for 75%).
          #
          # @return [void]
          # @raise [ActiveRecord::RecordInvalid] if save fails
          def update_performance_ratio!
            return unless total_capacity.to_f.positive?

            # Calculate performance ratio as a decimal (e.g., 0.75 for 75%)
            ratio = total_power_output.to_f / total_capacity.to_f
            self.attributes_data ||= {}
            attributes_data["performanceRatio"] = ratio
            save!
          end
        end
      end
    end
  end
end
