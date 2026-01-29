##
# Concern providing WeatherStation attribute accessors.
#
# Delegates to Asset::Type::Weather::Station::Attributes to avoid duplication.
# This module is extended on Asset instances via Assets::TypeDispatch.
#
module Assets
  module WeatherStationAttributes
    # Include Asset::Type::Weather::Station::Attributes to reuse its implementation
    # This ensures DRY: single source of truth for WeatherStation attribute methods
    # When this module is extended on an instance, these methods become instance methods
    include Asset::Type::Weather::Station::Attributes
  end
end
