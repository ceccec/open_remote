##
# Analytics helpers for aggregating `DataPoint` records using Arel.
#
# All methods expect the JSONB `value` column to contain a `"value"` key
# that can be cast to a numeric type in PostgreSQL.
#
# This module is intended to be included into `DataPoint`.
module DataPoint::Analytics
  extend ActiveSupport::Concern
  extend ConcernFeatures

  # Concern features - enables DataPoint interaction with Asset for analytics
  concern_feature :provides, :sum_for, :average_for, :max_for, :min_for, :create_continuous_aggregate
  enables_interaction :data_analytics, [ :DataPoint, :Asset ], "Enables DataPoint to perform analytics on Asset data"
  enables_interaction :time_series_analysis, [ :DataPoint ], "Enables time-series aggregation and analysis"

  class_methods do
    ##
    # Sum numeric values for an attribute over a time range.
    #
    # @param asset [Asset] asset whose datapoints are aggregated
    # @param attribute_name [String] attribute name to filter by
    # @param from [Time] inclusive lower bound of the time window
    # @param to [Time] inclusive upper bound of the time window
    # @return [Float] sum of all matching values, or `0.0` if none found
    def sum_for(asset:, attribute_name:, from:, to:)
        t = arel_table

        value_expr = Arel::Nodes::SqlLiteral.new(
          "(value->>'value')::float"
        )

        query = t
                .project(value_expr.sum.as("sum_value"))
                .where(
                  t[:asset_id].eq(asset.id)
                    .and(t[:attribute_name].eq(attribute_name))
                    .and(t[:timestamp].gteq(from))
                    .and(t[:timestamp].lteq(to))
                )

        result = connection.select_one(query.to_sql)
        result&.dig("sum_value")&.to_f || 0
    end

    ##
    # Average numeric values for an attribute over a time range.
    #
    # @param (see sum_for)
    # @return [Float, nil] average value, or `nil` when no datapoints match
    def average_for(asset:, attribute_name:, from:, to:)
        t = arel_table

        value_expr = Arel::Nodes::SqlLiteral.new(
          "(value->>'value')::float"
        )

        query = t
                .project(value_expr.average.as("avg_value"))
                .where(
                  t[:asset_id].eq(asset.id)
                    .and(t[:attribute_name].eq(attribute_name))
                    .and(t[:timestamp].gteq(from))
                    .and(t[:timestamp].lteq(to))
                )

        result = connection.select_one(query.to_sql)
        result&.dig("avg_value")&.to_f
    end

    ##
    # Maximum numeric value for an attribute over a time range.
    #
    # @param (see sum_for)
    # @return [Float, nil] maximum value, or `nil` when no datapoints match
    def max_for(asset:, attribute_name:, from:, to:)
        t = arel_table

        value_expr = Arel::Nodes::SqlLiteral.new(
          "(value->>'value')::float"
        )

        query = t
                .project(value_expr.maximum.as("max_value"))
                .where(
                  t[:asset_id].eq(asset.id)
                    .and(t[:attribute_name].eq(attribute_name))
                    .and(t[:timestamp].gteq(from))
                    .and(t[:timestamp].lteq(to))
                )

        result = connection.select_one(query.to_sql)
        result&.dig("max_value")&.to_f
    end

    ##
    # Minimum numeric value for an attribute over a time range.
    #
    # @param (see sum_for)
    # @return [Float, nil] minimum value, or `nil` when no datapoints match
    def min_for(asset:, attribute_name:, from:, to:)
        t = arel_table

        value_expr = Arel::Nodes::SqlLiteral.new(
          "(value->>'value')::float"
        )

        query = t
                .project(value_expr.minimum.as("min_value"))
                .where(
                  t[:asset_id].eq(asset.id)
                    .and(t[:attribute_name].eq(attribute_name))
                    .and(t[:timestamp].gteq(from))
                    .and(t[:timestamp].lteq(to))
                )

        result = connection.select_one(query.to_sql)
        result&.dig("min_value")&.to_f
    end

    ##
    # Create or update a TimescaleDB continuous aggregate materialized view.
    #
    # This is a no-op on databases without TimescaleDB installed; failures
    # are logged but not raised.
    #
    # @param name [String] SQL identifier for the materialized view
    # @param view_definition [String] SELECT query defining the aggregate
    # @return [void]
    def create_continuous_aggregate(name, view_definition)
        execute <<-SQL
          CREATE MATERIALIZED VIEW IF NOT EXISTS #{name}
          WITH (timescaledb.continuous) AS
          #{view_definition}
        SQL
    rescue ActiveRecord::StatementInvalid => e
      Rails.logger.warn "Could not create continuous aggregate: #{e.message}"
    end
  end
end
