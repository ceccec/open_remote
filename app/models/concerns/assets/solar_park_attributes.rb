##
# Concern providing SolarPark attribute accessors.
#
# Delegates to Asset::Type::Solar::Park::Attributes to avoid duplication.
# This module is extended on Asset instances via Assets::TypeDispatch.
#
module Assets
  module SolarParkAttributes
    # Include Asset::Type::Solar::Park::Attributes to reuse its implementation
    # This ensures DRY: single source of truth for SolarPark attribute methods
    # When this module is extended on an instance, these methods become instance methods
    include Asset::Type::Solar::Park::Attributes
  end
end
