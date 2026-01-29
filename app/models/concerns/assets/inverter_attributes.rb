##
# Concern providing Inverter attribute accessors.
#
# Delegates to Asset::Type::Inverter::Attributes to avoid duplication.
# This module is extended on Asset instances via Assets::TypeDispatch.
#
module Assets
  module InverterAttributes
    # Include Asset::Type::Inverter::Attributes to reuse its implementation
    # This ensures DRY: single source of truth for Inverter attribute methods
    # When this module is extended on an instance, these methods become instance methods
    include Asset::Type::Inverter::Attributes
  end
end
