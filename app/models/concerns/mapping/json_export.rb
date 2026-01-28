module Mapping
  module JsonExport
    extend ActiveSupport::Concern

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
