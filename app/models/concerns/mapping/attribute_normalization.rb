module Mapping
  module AttributeNormalization
    extend ActiveSupport::Concern

    class_methods do
      def normalize_openremote_attributes(attr_hash)
        return {} if attr_hash.blank?

        attr_hash.transform_values do |v|
          v.is_a?(Hash) && v.key?("value") ? v["value"] : v
        end
      end

      def denormalize_to_openremote_attributes(attrs)
        return {} if attrs.blank?

        attrs.transform_values { |v| { "value" => v } }
      end
    end
  end
end
