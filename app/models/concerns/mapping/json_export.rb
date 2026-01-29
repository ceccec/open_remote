##
# Provides JSON export functionality for OpenRemote JSON format.
#
# This concern enables models to export hierarchical structures to OpenRemote
# JSON format, preserving parent-child relationships recursively.
#
# @example Exporting to JSON
#   asset = Asset.find_by(name: "Solar Farm")
#   json = asset.to_openremote_json_tree
#   # => {
#   #      "name" => "Solar Farm",
#   #      "type" => "SolarPark",
#   #      "attributes" => { "totalCapacity" => 1000 },
#   #      "children" => [...]
#   #    }
#
module Mapping
  module JsonExport
    extend ActiveSupport::Concern
    extend ConcernFeatures

    # Concern features - enables Asset interaction with OpenRemote JSON format
    concern_feature :provides, :to_openremote_json_tree
    enables_interaction :json_export, [ :Asset ], "Enables Asset to export to OpenRemote JSON format, preserving hierarchy"

    ##
    # Export asset and its children to OpenRemote JSON format.
    #
    # Recursively converts the asset and all its descendants into a JSON-compatible
    # hash structure that matches the OpenRemote format. The resulting structure
    # can be serialized to JSON and imported back using `from_openremote_json`.
    #
    # @return [Hash] JSON-compatible hash with "name", "type", "attributes", and "children" keys
    # @example
    #   asset = Asset.find_by(name: "Solar Farm")
    #   json_tree = asset.to_openremote_json_tree
    #   JSON.pretty_generate(json_tree)
    def to_openremote_json_tree
      {
        "name" => name,
        "type" => asset_type.name,
        "attributes" => self.class.denormalize_to_openremote_attributes(attributes_data || {}),
        "children" => children.map(&:to_openremote_json_tree)
      }
    end
  end
end
