##
# Legacy module name for SolarPark attributes.
#
# This module delegates to Asset::Type::Solar::Park::Attributes to avoid duplication.
# It exists for backward compatibility with code that extends Asset::Type::SolarParkAttributes.
#
class Asset
  module Type
    module SolarParkAttributes
      # Include Asset::Type::Solar::Park::Attributes to reuse its implementation
      # This ensures DRY: single source of truth for SolarPark attribute methods
      include Asset::Type::Solar::Park::Attributes
    end
  end
end
