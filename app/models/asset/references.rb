##
# Reference helpers for Asset model.
#
# Provides methods for accessing and navigating associations,
# building reference chains, and resolving related entities.
#
# @example Get related data points
#   asset.related_data_points
#
# @example Build reference path
#   asset.reference_path
#
module Asset::References
  extend ActiveSupport::Concern

  included do
    ##
    # Get all data points for this asset.
    #
    # @param attribute_name [String, nil] optional attribute name filter
    # @return [ActiveRecord::Relation<DataPoint>] related data points
    #
    # @example
    #   asset.related_data_points
    #   asset.related_data_points("power")
    #
    def related_data_points(attribute_name = nil)
      relation = data_points
      relation = relation.where(attribute_name: attribute_name) if attribute_name
      relation
    end

    ##
    # Get the reference path as a string.
    #
    # Returns a human-readable path showing the asset hierarchy.
    #
    # @return [String] reference path
    #
    # @example
    #   asset.reference_path # => "Solar Park > Solar Farm > Array 1"
    #
    def reference_path
      reference_chain.join(" > ")
    end

    ##
    # Get the full reference chain including parent assets.
    #
    # Returns an array of asset names from root to current asset.
    #
    # @return [Array<String>] reference chain
    #
    # @example
    #   asset.reference_chain # => ["Solar Park", "Solar Farm", "Array 1"]
    #
    def reference_chain
      chain = []
      current = self
      while current
        chain.unshift(current.name)
        current = current.parent
      end
      chain
    end

    ##
    # Get all notifications for this asset.
    #
    # @return [ActiveRecord::Relation<Notification>] related notifications
    #
    # @example
    #   asset.related_notifications
    #
    def related_notifications
      notifications
    end

    ##
    # Get all rules that reference this asset or its type.
    #
    # @return [ActiveRecord::Relation<Rule>] potentially relevant rules
    #
    # @example
    #   asset.potentially_relevant_rules
    #
    def potentially_relevant_rules
      # Rules that might reference this asset type or attributes
      Rule.where(
        "when_config->>'condition' IN (?) OR then_config::text LIKE ?",
        [ "Asset attribute value", "Asset attribute value changed" ],
        "%#{asset_type&.name}%"
      )
    end

    ##
    # Get the asset type reference.
    #
    # @return [AssetType, nil] asset type
    #
    # @example
    #   asset.asset_type_reference # => #<AssetType name: "SolarArray">
    #
    def asset_type_reference
      asset_type
    end

    ##
    # Check if this asset references a specific parent.
    #
    # @param parent [Asset, Integer] parent asset or asset ID
    # @return [Boolean] true if references the parent
    #
    # @example
    #   asset.references_parent?(parent)
    #
    def references_parent?(parent)
      parent_id = parent.is_a?(Asset) ? parent.id : parent
      parent_id == self.parent_id
    end

    ##
    # Get all child assets recursively.
    #
    # @return [Array<Asset>] all descendant assets
    #
    # @example
    #   asset.all_descendants
    #
    def all_descendants
      descendants = []
      children.each do |child|
        descendants << child
        descendants.concat(child.all_descendants)
      end
      descendants
    end

    ##
    # Get all ancestor assets up to root.
    #
    # @return [Array<Asset>] all ancestor assets
    #
    # @example
    #   asset.all_ancestors
    #
    def all_ancestors
      ancestors = []
      current = parent
      while current
        ancestors << current
        current = current.parent
      end
      ancestors
    end

    ##
    # Get the root asset in the hierarchy.
    #
    # @return [Asset, nil] root asset
    #
    # @example
    #   asset.root_reference
    #
    def root_reference
      return self if parent.nil?

      current = self
      current = current.parent while current.parent
      current
    end
  end

  class_methods do
    ##
    # Find assets by asset type reference.
    #
    # @param asset_type [AssetType, Integer, String] asset type, ID, or name
    # @return [ActiveRecord::Relation<Asset>] matching assets
    #
    # @example
    #   Asset.by_asset_type_reference("SolarArray")
    #
    def by_asset_type_reference(asset_type)
      case asset_type
      when AssetType
        where(asset_type: asset_type)
      when Integer
        where(asset_type_id: asset_type)
      when String
        joins(:asset_type).where(asset_types: { name: asset_type })
      else
        none
      end
    end

    ##
    # Find assets by parent reference.
    #
    # @param parent [Asset, Integer, nil] parent asset, ID, or nil for root assets
    # @return [ActiveRecord::Relation<Asset>] matching assets
    #
    # @example
    #   Asset.by_parent_reference(parent)
    #   Asset.by_parent_reference(nil) # root assets
    #
    def by_parent_reference(parent)
      case parent
      when Asset
        where(parent: parent)
      when Integer
        where(parent_id: parent)
      when nil
        where(parent_id: nil)
      else
        none
      end
    end

    ##
    # Get all unique asset type references.
    #
    # Returns all asset types that have assets.
    #
    # @return [ActiveRecord::Relation<AssetType>] asset types with assets
    #
    # @example
    #   Asset.asset_type_references
    #
    def asset_type_references
      AssetType.joins(:assets).distinct
    end

    ##
    # Build a reference map of asset types to their assets.
    #
    # @return [Hash<AssetType => Array<Asset>>] reference map
    #
    # @example
    #   Asset.reference_map
    #
    def reference_map
      includes(:asset_type).group_by(&:asset_type)
    end

    ##
    # Get assets grouped by parent reference.
    #
    # @return [Hash<Integer => ActiveRecord::Relation<Asset>>] grouped assets
    #
    # @example
    #   Asset.grouped_by_parent_reference
    #
    def grouped_by_parent_reference
      group_by(&:parent_id)
    end
  end
end
