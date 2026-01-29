##
# Concern providing SolarArray attribute accessors.
#
# Delegates to Asset::Type::Solar::Array::Attributes to avoid duplication.
# This module is extended on Asset instances via Assets::TypeDispatch.
#
module Assets
  module SolarArrayAttributes
    # Include Asset::Type::Solar::Array::Attributes to reuse its implementation
    # This ensures DRY: single source of truth for SolarArray attribute methods
    # When this module is extended on an instance, these methods become instance methods
    include Asset::Type::Solar::Array::Attributes
  end
end
