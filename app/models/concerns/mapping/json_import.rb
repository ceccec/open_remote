##
# Provides JSON import functionality for OpenRemote JSON format.
#
# This concern enables models to import hierarchical JSON structures
# from OpenRemote format, creating parent-child relationships automatically.
#
# @example Importing from JSON
#   json_data = {
#     "name" => "Solar Farm",
#     "type" => "SolarArray",
#     "attributes" => { "capacity" => 1000 },
#     "children" => [...]
#   }
#   Asset.from_openremote_json(json_data)
#
module Mapping
  ##
  # Provides JSON import functionality for OpenRemote JSON format.
  #
  # This concern enables models to import hierarchical JSON structures
  # from OpenRemote format, creating parent-child relationships automatically.
  #
  # @example Importing from JSON
  #   json_data = {
  #     "name" => "Solar Farm",
  #     "type" => "SolarArray",
  #     "attributes" => { "capacity" => 1000 },
  #     "children" => [...]
  #   }
  #   Asset.from_openremote_json(json_data)
  #
  module JsonImport
    extend ActiveSupport::Concern
    extend ConcernFeatures

    # Concern features - enables Asset interaction with OpenRemote JSON format
    concern_feature :provides, :from_openremote_json
    enables_interaction :json_import, [ :Asset ], "Enables Asset to import from OpenRemote JSON format, creating hierarchical structures"

    class_methods do
      ##
      # Import an asset from OpenRemote JSON format.
      #
      # Recursively creates assets and their children from a JSON node structure.
      #
      # @param node [Hash] JSON node with "name", "type", "attributes", and optional "children"
      # @param parent [Asset, nil] Parent asset for this node
      # @return [Asset] The created or updated asset
      #
      # @example
      #   json = { "name" => "Farm", "type" => "SolarArray", "attributes" => {} }
      #   Asset.from_openremote_json(json)
      #
      def from_openremote_json(node, parent: nil)
        type = AssetType.find_or_create_by!(name: node["type"])
        attrs = normalize_openremote_attributes(node["attributes"] || {})

        # Use find_or_initialize_by with parent to ensure correct hierarchy
        # If parent is nil, search without parent constraint
        asset = if parent
          find_or_initialize_by(name: node["name"], asset_type: type, parent: parent)
        else
          find_or_initialize_by(name: node["name"], asset_type: type) do |a|
            a.parent = nil
          end
        end
        asset.attributes_data = attrs
        asset.save!

        # Process children in order to maintain JSON structure
        (node["children"] || []).each do |child_node|
          from_openremote_json(child_node, parent: asset)
        end

        # Reload to ensure children association is fresh
        asset.reload
        asset
      end
    end
  end
end
