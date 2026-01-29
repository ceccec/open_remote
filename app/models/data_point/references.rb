##
# Reference helpers for DataPoint model.
#
# Provides methods for accessing and navigating associations,
# building reference chains, and resolving related entities.
#
# @example Get related assets
#   data_point.related_assets
#
# @example Build reference path
#   data_point.reference_path
#
module DataPoint::References
  extend ActiveSupport::Concern

  included do
    ##
    # Get all assets related to this data point through its attribute.
    #
    # Returns assets that have data points with the same attribute name.
    #
    # @return [ActiveRecord::Relation<Asset>] related assets
    #
    # @example
    #   data_point.related_assets
    #
    def related_assets
      Asset.joins(:data_points)
        .where(data_points: { attribute_name: attribute_name })
        .distinct
    end

    ##
    # Get the reference path as a string.
    #
    # Returns a human-readable path showing the asset and attribute.
    #
    # @return [String] reference path
    #
    # @example
    #   data_point.reference_path # => "Solar Farm > power"
    #
    def reference_path
      parts = []
      parts << asset&.name if asset
      parts << attribute_name if attribute_name
      parts.join(" > ")
    end

    ##
    # Get the full reference chain including parent assets.
    #
    # Returns an array of asset names from root to current asset.
    #
    # @return [Array<String>] reference chain
    #
    # @example
    #   data_point.reference_chain # => ["Solar Park", "Solar Farm", "Array 1"]
    #
    def reference_chain
      return [] unless asset

      chain = []
      current = asset
      while current
        chain.unshift(current.name)
        current = current.parent
      end
      chain
    end

    ##
    # Get related data points with the same attribute name.
    #
    # @param scope [Symbol, nil] scope to apply (:recent, :for_asset, etc.)
    # @return [ActiveRecord::Relation<DataPoint>] related data points
    #
    # @example
    #   data_point.related_data_points(:recent)
    #
    def related_data_points(scope = nil)
      relation = DataPoint.where(attribute_name: attribute_name)
      relation = relation.public_send(scope) if scope && respond_to?(scope)
      relation.where.not(id: id)
    end

    ##
    # Get the asset type reference.
    #
    # @return [AssetType, nil] asset type
    #
    # @example
    #   data_point.asset_type_reference # => #<AssetType name: "SolarArray">
    #
    def asset_type_reference
      asset&.asset_type
    end

    ##
    # Check if this data point references a specific asset.
    #
    # @param asset [Asset, Integer] asset or asset ID
    # @return [Boolean] true if references the asset
    #
    # @example
    #   data_point.references_asset?(asset)
    #
    def references_asset?(asset)
      asset_id = asset.is_a?(Asset) ? asset.id : asset
      asset_id == self.asset_id
    end

    ##
    # Get all notifications related to this data point's asset.
    #
    # @return [ActiveRecord::Relation<Notification>] related notifications
    #
    # @example
    #   data_point.related_notifications
    #
    def related_notifications
      return Notification.none unless asset

      Notification.where(asset: asset)
    end

    ##
    # Get all rules that might be triggered by this data point.
    #
    # Returns rules that reference the same attribute name or asset type.
    #
    # @return [ActiveRecord::Relation<Rule>] potentially relevant rules
    #
    # @example
    #   data_point.potentially_relevant_rules
    #
    def potentially_relevant_rules
      return Rule.none unless asset

      # Rules that check attribute values or changes
      Rule.where(
        "when_config->>'condition' IN (?)",
        [ "Asset attribute value", "Asset attribute value changed" ]
      )
    end
  end

  class_methods do
    ##
    # Find data points by asset reference.
    #
    # @param asset [Asset, Integer, String] asset, asset ID, or asset name
    # @return [ActiveRecord::Relation<DataPoint>] matching data points
    #
    # @example
    #   DataPoint.by_asset_reference(asset)
    #   DataPoint.by_asset_reference("Solar Farm")
    #
    def by_asset_reference(asset)
      case asset
      when Asset
        where(asset: asset)
      when Integer
        where(asset_id: asset)
      when String
        joins(:asset).where(assets: { name: asset })
      else
        none
      end
    end

    ##
    # Find data points by asset type reference.
    #
    # @param asset_type [AssetType, Integer, String] asset type, ID, or name
    # @return [ActiveRecord::Relation<DataPoint>] matching data points
    #
    # @example
    #   DataPoint.by_asset_type_reference("SolarArray")
    #
    def by_asset_type_reference(asset_type)
      case asset_type
      when AssetType
        joins(:asset).where(assets: { asset_type_id: asset_type.id })
      when Integer
        joins(:asset).where(assets: { asset_type_id: asset_type })
      when String
        joins(asset: :asset_type).where(asset_types: { name: asset_type })
      else
        none
      end
    end

    ##
    # Get all unique asset references.
    #
    # Returns all assets that have data points.
    #
    # @return [ActiveRecord::Relation<Asset>] assets with data points
    #
    # @example
    #   DataPoint.asset_references
    #
    def asset_references
      Asset.joins(:data_points).distinct
    end

    ##
    # Get all unique attribute name references.
    #
    # @return [Array<String>] unique attribute names
    #
    # @example
    #   DataPoint.attribute_references
    #
    def attribute_references
      distinct.pluck(:attribute_name).compact.sort
    end

    ##
    # Build a reference map of assets to their data points.
    #
    # @return [Hash<Asset => Array<DataPoint>>] reference map
    #
    # @example
    #   DataPoint.reference_map
    #
    def reference_map
      includes(:asset).group_by(&:asset)
    end

    ##
    # Get data points grouped by asset reference.
    #
    # @return [Hash<Integer => ActiveRecord::Relation<DataPoint>>] grouped data points
    #
    # @example
    #   DataPoint.grouped_by_asset_reference
    #
    def grouped_by_asset_reference
      group_by(&:asset_id)
    end
  end
end
