##
# Concern providing EnergyMeter attribute accessors.
#
# Delegates to Asset::Type::Energy::Meter::Attributes to avoid duplication.
# This module is extended on Asset instances via Assets::TypeDispatch.
#
module Assets
  module EnergyMeterAttributes
    # Include Asset::Type::Energy::Meter::Attributes to reuse its implementation
    # This ensures DRY: single source of truth for EnergyMeter attribute methods
    # When this module is extended on an instance, these methods become instance methods
    include Asset::Type::Energy::Meter::Attributes
  end
end
