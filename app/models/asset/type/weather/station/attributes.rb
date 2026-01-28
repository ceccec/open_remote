class Asset
  module Type
    module Weather
      module Station
        module Attributes
          def temperature
            (attributes_data || {})["temperature"]
          end

          def humidity
            (attributes_data || {})["humidity"]
          end

          def pressure
            (attributes_data || {})["pressure"]
          end

          def wind_speed
            (attributes_data || {})["windSpeed"]
          end

          def wind_direction
            (attributes_data || {})["windDirection"]
          end

          def solar_irradiance
            (attributes_data || {})["solarIrradiance"]
          end

          def cloud_cover
            (attributes_data || {})["cloudCover"]
          end

          def visibility
            (attributes_data || {})["visibility"]
          end

          def location
            (attributes_data || {})["location"]
          end
        end
      end
    end
  end
end
