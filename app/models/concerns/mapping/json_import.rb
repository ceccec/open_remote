module Mapping
  module JsonImport
    extend ActiveSupport::Concern

    class_methods do
      def from_openremote_json(node, parent: nil)
        type = AssetType.find_or_create_by!(name: node["type"])
        attrs = normalize_openremote_attributes(node["attributes"] || {})

        asset = find_or_initialize_by(name: node["name"], asset_type: type, parent: parent)
        asset.attributes_data = attrs
        asset.save!

        (node["children"] || []).each do |child_node|
          from_openremote_json(child_node, parent: asset)
        end

        asset
      end
    end
  end
end
