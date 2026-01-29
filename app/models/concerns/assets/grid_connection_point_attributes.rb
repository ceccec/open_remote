##
# Concern providing GridConnectionPoint attribute accessors.
#
# Delegates to Asset::Type::Grid::Connection::Point::Attributes to avoid duplication.
# This module is extended on Asset instances via Assets::TypeDispatch.
#
module Assets
  module GridConnectionPointAttributes
    # Include Asset::Type::Grid::Connection::Point::Attributes to reuse its implementation
    # This ensures DRY: single source of truth for GridConnectionPoint attribute methods
    # When this module is extended on an instance, these methods become instance methods
    include Asset::Type::Grid::Connection::Point::Attributes
  end
end
