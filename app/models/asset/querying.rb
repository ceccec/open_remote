##
# Querying concern for Asset model.
#
# Provides specialized query methods for filtering and querying assets,
# including type-specific queries and JSONB attribute queries.
#
# @example Query solar arrays
#   Asset.solar_arrays
#
# @example Query assets by type
#   Asset.of_type("SolarPark")
#
# @example Query assets with numeric attribute greater than value
#   Asset.with_numeric_attribute_greater_than("powerOutput", 1000)
#
class Asset
  module Querying
    extend ActiveSupport::Concern

    class_methods do
      ##
      # Find all assets of type SolarArray.
      #
      # @return [ActiveRecord::Relation<Asset>] solar array assets
      def solar_arrays
        joins(:asset_type).where(asset_types: { name: "SolarArray" })
      end

      ##
      # Find all assets of type SolarPark.
      #
      # @return [ActiveRecord::Relation<Asset>] solar park assets
      def solar_parks
        joins(:asset_type).where(asset_types: { name: "SolarPark" })
      end

      ##
      # Find all assets of a specific type.
      #
      # @param type_name [String] name of the asset type
      # @return [ActiveRecord::Relation<Asset>] assets of the specified type
      def of_type(type_name)
        joins(:asset_type).where(asset_types: { name: type_name })
      end

      ##
      # Extract power output values from all SolarArray assets.
      #
      # Uses Arel to build a SQL query that extracts the "powerOutput"
      # attribute from the JSONB attributes_data column and casts it to float.
      #
      # @return [Array<Array<String, Float>>] array of [asset_id, power_output] pairs
      # @example
      #   Asset.solar_array_power_outputs
      #   # => [["uuid-1", 1500.0], ["uuid-2", 2000.0]]
      def solar_array_power_outputs
        t = arel_table
        asset_types_t = AssetType.arel_table

        # Extract powerOutput from JSONB and cast to float
        # Uses PostgreSQL JSONB operator ->> to extract text, then ::float to cast
        expr = Arel::Nodes::SqlLiteral.new(
          "(#{table_name}.attributes_data ->> #{connection.quote('powerOutput')})::float"
        )

        # Build Arel query: SELECT id, power_output FROM assets
        # JOIN asset_types WHERE asset_types.name = 'SolarArray'
        query = t
                .project(t[:id], expr.as("power_output"))
                .join(asset_types_t).on(asset_types_t[:id].eq(t[:asset_type_id]))
                .where(asset_types_t[:name].eq("SolarArray"))

        # Execute raw SQL and map results to [id, power_output] pairs
        connection.select_all(query.to_sql).map do |row|
          [ row["id"], row["power_output"].to_f ]
        end
      end

      ##
      # Find assets where a numeric attribute exceeds a given value.
      #
      # Extracts the specified attribute from the JSONB attributes_data column,
      # casts it to float, and compares it to the given value.
      #
      # @param attr_name [String] name of the attribute in attributes_data
      # @param value [Numeric] threshold value to compare against
      # @return [ActiveRecord::Relation<Asset>] assets where attribute > value
      # @example
      #   Asset.with_numeric_attribute_greater_than("powerOutput", 1000)
      def with_numeric_attribute_greater_than(attr_name, value)
        t = arel_table
        # Build SQL condition: extract JSONB attribute, cast to float, compare
        # Uses PostgreSQL JSONB operator ->> for safe attribute extraction
        condition = Arel::Nodes::SqlLiteral.new(
          "((#{table_name}.attributes_data ->> #{connection.quote(attr_name)})::float > #{connection.quote(value)})"
        )
        where(condition)
      end
    end
  end
end
