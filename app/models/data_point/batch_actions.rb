##
# Batch actions specific to DataPoint model.
#
# Provides specialized batch operations for time-series data points,
# such as bulk cleanup, aggregation, and archival operations.
#
# @example Batch cleanup old data points
#   DataPoint.batch_cleanup_older_than(1.month.ago)
#
# @example Batch archive data points
#   DataPoint.batch_archive([1, 2, 3])
#
module DataPoint::BatchActions
  extend ActiveSupport::Concern

    class_methods do
      ##
      # Delete data points older than a given timestamp.
      #
      # @param timestamp [Time, DateTime] cutoff timestamp
      # @param batch_size [Integer] number of records to delete per batch (default: 1000)
      # @return [Integer] total number of records deleted
      #
      # @example
      #   DataPoint.batch_cleanup_older_than(1.month.ago)
      #   DataPoint.batch_cleanup_older_than(Time.parse("2024-01-01"), batch_size: 500)
      #
      def batch_cleanup_older_than(timestamp, batch_size: 1000)
        return 0 unless timestamp

        total_deleted = 0
        relation = where("timestamp < ?", timestamp)

        loop do
          batch_ids = relation.limit(batch_size).pluck(:id)
          break if batch_ids.empty?

          deleted = where(id: batch_ids).delete_all
          total_deleted += deleted
          break if deleted < batch_size
        end

        total_deleted
      end

      ##
      # Delete data points for a specific asset older than a given timestamp.
      #
      # @param asset [Asset, Integer] asset or asset ID
      # @param timestamp [Time, DateTime] cutoff timestamp
      # @param batch_size [Integer] number of records to delete per batch (default: 1000)
      # @return [Integer] total number of records deleted
      #
      # @example
      #   DataPoint.batch_cleanup_for_asset(asset, 1.month.ago)
      #
      def batch_cleanup_for_asset(asset, timestamp, batch_size: 1000)
        asset_id = asset.is_a?(Asset) ? asset.id : asset
        return 0 unless asset_id && timestamp

        total_deleted = 0
        relation = where(asset_id: asset_id).where("timestamp < ?", timestamp)

        loop do
          batch_ids = relation.limit(batch_size).pluck(:id)
          break if batch_ids.empty?

          deleted = where(id: batch_ids).delete_all
          total_deleted += deleted
          break if deleted < batch_size
        end

        total_deleted
      end

      ##
      # Delete data points for a specific attribute name older than a given timestamp.
      #
      # @param attribute_name [String] attribute name to filter by
      # @param timestamp [Time, DateTime] cutoff timestamp
      # @param batch_size [Integer] number of records to delete per batch (default: 1000)
      # @return [Integer] total number of records deleted
      #
      # @example
      #   DataPoint.batch_cleanup_for_attribute("power", 1.month.ago)
      #
      def batch_cleanup_for_attribute(attribute_name, timestamp, batch_size: 1000)
        return 0 unless attribute_name.present? && timestamp

        total_deleted = 0
        relation = where(attribute_name: attribute_name).where("timestamp < ?", timestamp)

        loop do
          batch_ids = relation.limit(batch_size).pluck(:id)
          break if batch_ids.empty?

          deleted = where(id: batch_ids).delete_all
          total_deleted += deleted
          break if deleted < batch_size
        end

        total_deleted
      end

      ##
      # Batch update data point values with a transformation function.
      #
      # @param ids [Array<Integer>, ActiveRecord::Relation] IDs or relation to update
      # @param block [Proc] transformation block that receives the value hash and returns updated value
      # @return [Hash] results with :success, :failed, and :errors keys
      #
      # @example
      #   DataPoint.batch_transform_values([1, 2, 3]) do |value|
      #     value.merge("normalized" => value["value"].to_f * 1000)
      #   end
      #
      def batch_transform_values(ids, &block)
        relation = ids.is_a?(ActiveRecord::Relation) ? ids : where(id: ids)
        results = { success: 0, failed: 0, errors: [] }

        relation.find_each do |data_point|
          new_value = block.call(data_point.value || {})
          data_point.update!(value: new_value)
          results[:success] += 1
        rescue StandardError => e
          results[:failed] += 1
          results[:errors] << { id: data_point.id, error: e.message }
        end

        results
      end

      ##
      # Batch delete duplicate data points, keeping only the most recent.
      #
      # Identifies duplicates by asset_id, attribute_name, and timestamp,
      # keeping the one with the highest ID (most recent).
      #
      # @param batch_size [Integer] number of records to process per batch (default: 1000)
      # @return [Integer] total number of duplicates deleted
      #
      # @example
      #   DataPoint.batch_delete_duplicates
      #
      def batch_delete_duplicates(batch_size: 1000)
        total_deleted = 0

        # Find duplicate groups
        duplicate_groups = select(:asset_id, :attribute_name, :timestamp)
          .group(:asset_id, :attribute_name, :timestamp)
          .having("COUNT(*) > 1")
          .pluck(:asset_id, :attribute_name, :timestamp)

        duplicate_groups.each do |asset_id, attribute_name, timestamp|
          # Keep the most recent (highest ID), delete the rest
          duplicates = where(
            asset_id: asset_id,
            attribute_name: attribute_name,
            timestamp: timestamp
          ).order(id: :desc)

          # Skip the first (keep it), delete the rest
          to_delete = duplicates.offset(1).limit(batch_size)
          deleted = to_delete.delete_all
          total_deleted += deleted
        end

        total_deleted
      end

      ##
      # Batch aggregate data points by time window.
      #
      # Groups data points by asset, attribute_name, and time window,
      # then creates aggregated records (e.g., hourly averages).
      #
      # @param window_size [String] time window size (e.g., "1 hour", "1 day")
      # @param aggregation [Symbol] aggregation function (:avg, :sum, :min, :max)
      # @param from_time [Time, nil] start time (default: 1 month ago)
      # @param to_time [Time, nil] end time (default: now)
      # @return [Hash] results with :created, :skipped, and :errors keys
      #
      # @example
      #   DataPoint.batch_aggregate_by_window("1 hour", :avg, from_time: 1.day.ago)
      #
      def batch_aggregate_by_window(window_size, aggregation = :avg, from_time: nil, to_time: nil)
        from_time ||= 1.month.ago
        to_time ||= Time.current

        results = { created: 0, skipped: 0, errors: [] }

        # Group by asset_id and attribute_name
        groups = where(timestamp: from_time..to_time)
          .select(:asset_id, :attribute_name)
          .distinct
          .pluck(:asset_id, :attribute_name)

        groups.each do |asset_id, attribute_name|
          data_points = where(
            asset_id: asset_id,
            attribute_name: attribute_name,
            timestamp: from_time..to_time
          ).order(:timestamp)

          # Group by time window
          windowed = data_points.group_by do |dp|
            # Calculate window start time
            window_start = case window_size
            when /(\d+)\s*hour/i
              dp.timestamp.beginning_of_hour + ($1.to_i * (dp.timestamp.hour / $1.to_i).floor).hours
            when /(\d+)\s*day/i
              dp.timestamp.beginning_of_day + ($1.to_i * (dp.timestamp.day / $1.to_i).floor).days
            else
              dp.timestamp.beginning_of_hour
            end
            [ asset_id, attribute_name, window_start ]
          end

          windowed.each do |(_asset_id, _attr_name, window_start), points|
            next if points.empty?

            # Calculate aggregated value
            values = points.map { |dp| extract_numeric_value(dp.value) }.compact
            next if values.empty?

            aggregated_value = case aggregation
            when :avg
              values.sum.to_f / values.length
            when :sum
              values.sum
            when :min
              values.min
            when :max
              values.max
            else
              values.sum.to_f / values.length # default to average
            end

            # Create aggregated data point
            create!(
              asset_id: asset_id,
              attribute_name: "#{attribute_name}_#{aggregation}",
              value: { value: aggregated_value, aggregated: true, count: values.length },
              timestamp: window_start
            )
            results[:created] += 1
          rescue StandardError => e
            results[:errors] << {
              asset_id: asset_id,
              attribute_name: attribute_name,
              window_start: window_start,
              error: e.message
            }
          end
        end

        results
      end

      private

      ##
      # Extract numeric value from data point value hash.
      #
      # @param value [Hash] data point value hash
      # @return [Numeric, nil] extracted numeric value
      #
      def extract_numeric_value(value)
        return nil unless value.is_a?(Hash)

        # Try common value keys
        val = value["value"] || value[:value] || value["data"] || value[:data]
        return val.to_f if val.respond_to?(:to_f)

        nil
      end
    end
end
