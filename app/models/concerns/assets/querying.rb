module Assets
  module Querying
    extend ActiveSupport::Concern

    class_methods do
      def solar_arrays
        joins(:asset_type).where(asset_types: { name: "SolarArray" })
      end

      def solar_parks
        joins(:asset_type).where(asset_types: { name: "SolarPark" })
      end

      def of_type(type_name)
        joins(:asset_type).where(asset_types: { name: type_name })
      end

      def solar_array_power_outputs
        # Iterate over records and extract both ID and power output
        # Using records ensures UUIDs are handled correctly by ActiveRecord
        solar_arrays.includes(:asset_type).map do |asset|
          power_output = (asset.attributes_data || {})["powerOutput"]
          power_output = power_output.to_f if power_output
          # asset.id should already be a UUID string, but ensure it's a string
          id_str = asset.id.is_a?(String) ? asset.id : asset.id.to_s
          [ id_str, power_output.to_f ]
        end
      end

      def with_numeric_attribute_greater_than(attr_name, value)
        t = arel_table
        condition = Arel::Nodes::SqlLiteral.new(
          "((#{table_name}.attributes_data ->> #{connection.quote(attr_name)})::float > #{connection.quote(value)})"
        )
        where(condition)
      end
    end
  end
end
