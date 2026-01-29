##
# Provides batch action functionality for ActiveRecord models.
#
# This concern enables models to perform operations on multiple records
# simultaneously, useful for admin interfaces and bulk operations.
#
# @example Batch enable/disable
#   Rule.batch_enable([1, 2, 3])
#   Rule.batch_disable([1, 2, 3])
#
# @example Batch update attributes
#   Asset.batch_update([1, 2, 3], { parent_id: 5 })
#
# @example Batch delete
#   Notification.batch_delete([1, 2, 3])
#
module BatchActions
  extend ActiveSupport::Concern
  extend ConcernFeatures

  # Concern features - enables batch operations on models
  concern_feature :provides, :batch_enable, :batch_disable, :batch_update, :batch_delete
  enables_interaction :batch_operations, [ :Asset, :Rule, :Notification, :DataPoint ], "Enables batch operations on multiple records"

  class_methods do
    ##
    # Enable multiple records by ID.
    #
    # @param ids [Array<Integer>, ActiveRecord::Relation] IDs or relation to enable
    # @return [Integer] number of records updated
    #
    # @example
    #   Rule.batch_enable([1, 2, 3])
    #   Rule.batch_enable(Rule.disabled)
    #
    def batch_enable(ids)
      return 0 unless column_names.include?("enabled")

      relation = ids.is_a?(ActiveRecord::Relation) ? ids : where(id: ids)
      count = relation.count
      relation.update_all(enabled: true)
      count
    end

    ##
    # Disable multiple records by ID.
    #
    # @param ids [Array<Integer>, ActiveRecord::Relation] IDs or relation to disable
    # @return [Integer] number of records updated
    #
    # @example
    #   Rule.batch_disable([1, 2, 3])
    #   Rule.batch_disable(Rule.enabled)
    #
    def batch_disable(ids)
      return 0 unless column_names.include?("enabled")

      relation = ids.is_a?(ActiveRecord::Relation) ? ids : where(id: ids)
      count = relation.count
      relation.update_all(enabled: false)
      count
    end

    ##
    # Update multiple records with the same attributes.
    #
    # @param ids [Array<Integer>, ActiveRecord::Relation] IDs or relation to update
    # @param attributes [Hash] attributes to update
    # @return [Integer] number of records updated
    #
    # @example
    #   Asset.batch_update([1, 2, 3], { parent_id: 5 })
    #   Notification.batch_update([1, 2, 3], { acknowledged_at: Time.current })
    #
    def batch_update(ids, attributes)
      return 0 if attributes.blank?

      relation = ids.is_a?(ActiveRecord::Relation) ? ids : where(id: ids)
      # For relations, convert to IDs first to ensure consistent behavior
      # This handles cases where the relation might have joins or complex conditions
      if ids.is_a?(ActiveRecord::Relation)
        target_ids = relation.pluck(:id)
        return 0 if target_ids.empty?
        count = target_ids.count
        where(id: target_ids).update_all(attributes)
        count
      else
        # For array of IDs, use directly
        count = relation.count
        relation.update_all(attributes)
        count
      end
    end

    ##
    # Delete multiple records by ID.
    #
    # @param ids [Array<Integer>, ActiveRecord::Relation] IDs or relation to delete
    # @return [Integer] number of records deleted
    #
    # @example
    #   Notification.batch_delete([1, 2, 3])
    #   DataPoint.batch_delete(DataPoint.where("timestamp < ?", 1.month.ago))
    #
    def batch_delete(ids)
      relation = ids.is_a?(ActiveRecord::Relation) ? ids : where(id: ids)
      count = relation.count
      relation.delete_all
      count
    end

    ##
    # Acknowledge multiple notifications.
    #
    # @param ids [Array<Integer>, ActiveRecord::Relation] IDs or relation to acknowledge
    # @return [Integer] number of records updated
    #
    # @example
    #   Notification.batch_acknowledge([1, 2, 3])
    #
    def batch_acknowledge(ids)
      return 0 unless column_names.include?("acknowledged_at")

      relation = ids.is_a?(ActiveRecord::Relation) ? ids : where(id: ids)
      count = relation.count
      relation.update_all(acknowledged_at: Time.current)
      count
    end

    ##
    # Assign multiple assets to a parent.
    #
    # @param ids [Array<Integer>, ActiveRecord::Relation] IDs or relation to assign
    # @param parent_id [Integer, nil] Parent asset ID, or nil to make root assets
    # @return [Integer] number of records updated
    #
    # @example
    #   Asset.batch_assign_parent([1, 2, 3], 5)
    #   Asset.batch_assign_parent([1, 2, 3], nil) # Make root assets
    #
    def batch_assign_parent(ids, parent_id)
      return 0 unless column_names.include?("parent_id")

      relation = ids.is_a?(ActiveRecord::Relation) ? ids : where(id: ids)
      count = relation.count
      relation.update_all(parent_id: parent_id)
      count
    end

    ##
    # Execute a custom batch action on multiple records.
    #
    # @param ids [Array<Integer>, ActiveRecord::Relation] IDs or relation to process
    # @param action [Symbol, String] action name to perform
    # @param args [Array] additional arguments for the action
    # @return [Hash] results with :success, :failed, and :errors keys
    #
    # @example
    #   Rule.batch_execute([1, 2, 3], :execute!)
    #   Asset.batch_execute([1, 2, 3], :to_openremote_json_tree)
    #
    def batch_execute(ids, action, *args)
      relation = ids.is_a?(ActiveRecord::Relation) ? ids : where(id: ids)
      results = { success: 0, failed: 0, errors: [] }

      relation.find_each do |record|
        if record.respond_to?(action)
          record.public_send(action, *args)
          results[:success] += 1
        else
          results[:failed] += 1
          results[:errors] << { id: record.id, error: "Method #{action} not available" }
        end
      rescue StandardError => e
        results[:failed] += 1
        results[:errors] << { id: record.id, error: e.message }
      end

      results
    end
  end
end
