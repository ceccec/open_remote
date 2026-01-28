class Asset
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
        t = arel_table
        asset_types_t = AssetType.arel_table

        expr = Arel::Nodes::SqlLiteral.new(
          "(#{table_name}.attributes_data ->> #{connection.quote('powerOutput')})::float"
        )

        query = t
                .project(t[:id], expr.as("power_output"))
                .join(asset_types_t).on(asset_types_t[:id].eq(t[:asset_type_id]))
                .where(asset_types_t[:name].eq("SolarArray"))

        # Return UUID id and numeric power output as floats
        connection.select_all(query.to_sql).map do |row|
          [ row["id"], row["power_output"].to_f ]
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
