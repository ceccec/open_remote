##
# Attribute normalization for OpenRemote JSON format conversion.
#
# Provides methods to convert between OpenRemote's nested attribute format
# (where values are wrapped in `{"value": ...}`) and the flat format used
# internally in attributes_data.
#
# @example Normalizing OpenRemote attributes
#   openremote_attrs = { "capacity" => { "value" => 1000 } }
#   Asset.normalize_openremote_attributes(openremote_attrs)
#   # => { "capacity" => 1000 }
#
# @example Denormalizing to OpenRemote format
#   flat_attrs = { "capacity" => 1000 }
#   Asset.denormalize_to_openremote_attributes(flat_attrs)
#   # => { "capacity" => { "value" => 1000 } }
#
module Mapping
  module AttributeNormalization
    extend ActiveSupport::Concern

    class_methods do
      ##
      # Normalize OpenRemote attributes from nested format to flat format.
      #
      # Converts attributes from OpenRemote's format where values are wrapped
      # in `{"value": ...}` to a flat hash format used internally.
      #
      # @param attr_hash [Hash] OpenRemote-style attributes hash
      # @return [Hash] normalized flat attributes hash
      # @example
      #   Asset.normalize_openremote_attributes({ "capacity" => { "value" => 1000 } })
      #   # => { "capacity" => 1000 }
      def normalize_openremote_attributes(attr_hash)
        return {} if attr_hash.blank?

        attr_hash.transform_values do |v|
          v.is_a?(Hash) && v.key?("value") ? v["value"] : v
        end
      end

      ##
      # Denormalize flat attributes to OpenRemote nested format.
      #
      # Converts flat attributes to OpenRemote's format where values are wrapped
      # in `{"value": ...}` for export.
      #
      # @param attrs [Hash] flat attributes hash
      # @return [Hash] OpenRemote-style nested attributes hash
      # @example
      #   Asset.denormalize_to_openremote_attributes({ "capacity" => 1000 })
      #   # => { "capacity" => { "value" => 1000 } }
      def denormalize_to_openremote_attributes(attrs)
        return {} if attrs.blank?

        attrs.transform_values { |v| { "value" => v } }
      end
    end
  end
end
