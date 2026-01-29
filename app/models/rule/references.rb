##
# Reference helpers for Rule model.
#
# Provides methods for accessing and navigating associations,
# building reference chains, and resolving related entities.
#
# @example Get related rule executions
#   rule.related_executions
#
# @example Get referenced assets
#   rule.referenced_assets
#
module Rule::References
  extend ActiveSupport::Concern

  included do
    ##
    # Get all rule executions for this rule.
    #
    # @return [ActiveRecord::Relation<RuleExecution>] related executions
    #
    # @example
    #   rule.related_executions
    #
    def related_executions
      rule_executions
    end

    ##
    # Get the reference path as a string.
    #
    # Returns a human-readable path showing the rule name and status.
    #
    # @return [String] reference path
    #
    # @example
    #   rule.reference_path # => "Temperature Alert (enabled)"
    #
    def reference_path
      parts = [ name ]
      parts << "(#{enabled? ? 'enabled' : 'disabled'})" if respond_to?(:enabled?)
      parts.join(" ")
    end

    ##
    # Get all notifications triggered by this rule.
    #
    # @return [ActiveRecord::Relation<Notification>] related notifications
    #
    # @example
    #   rule.related_notifications
    #
    def related_notifications
      Notification.where(rule: self)
    end

    ##
    # Get assets that might be referenced by this rule's configuration.
    #
    # Attempts to extract asset references from when_config and then_config.
    #
    # @return [ActiveRecord::Relation<Asset>] potentially referenced assets
    #
    # @example
    #   rule.referenced_assets
    #
    def referenced_assets
      # Extract asset type names from configuration
      asset_type_names = extract_asset_type_references

      return Asset.none if asset_type_names.empty?

      Asset.joins(:asset_type)
        .where(asset_types: { name: asset_type_names })
        .distinct
    end

    ##
    # Get asset types referenced by this rule.
    #
    # @return [ActiveRecord::Relation<AssetType>] referenced asset types
    #
    # @example
    #   rule.referenced_asset_types
    #
    def referenced_asset_types
      asset_type_names = extract_asset_type_references
      return AssetType.none if asset_type_names.empty?

      AssetType.where(name: asset_type_names)
    end

    ##
    # Check if this rule references a specific asset type.
    #
    # @param asset_type [AssetType, String] asset type or name
    # @return [Boolean] true if references the asset type
    #
    # @example
    #   rule.references_asset_type?("SolarArray")
    #
    def references_asset_type?(asset_type)
      asset_type_name = asset_type.is_a?(AssetType) ? asset_type.name : asset_type
      extract_asset_type_references.include?(asset_type_name)
    end

    private

    ##
    # Extract asset type names from rule configuration.
    #
    # @return [Array<String>] asset type names
    #
    def extract_asset_type_references
      names = []
      config = when_config || {}
      then_config_array = then_config.is_a?(Array) ? then_config : [ then_config ].compact

      # Extract from when_config
      if config["assetType"]
        names << config["assetType"]
      end

      # Extract from then_config actions
      then_config_array.each do |action|
        if action.is_a?(Hash)
          names << action["assetType"] if action["assetType"]
          names << action["targetAssetType"] if action["targetAssetType"]
        end
      end

      names.compact.uniq
    end
  end

  class_methods do
    ##
    # Find rules by asset type reference.
    #
    # @param asset_type [AssetType, String] asset type or name
    # @return [ActiveRecord::Relation<Rule>] matching rules
    #
    # @example
    #   Rule.by_asset_type_reference("SolarArray")
    #
    def by_asset_type_reference(asset_type)
      asset_type_name = asset_type.is_a?(AssetType) ? asset_type.name : asset_type.to_s

      where(
        "when_config::text LIKE ? OR then_config::text LIKE ?",
        "%\"assetType\":\"#{asset_type_name}\"%",
        "%\"assetType\":\"#{asset_type_name}\"%"
      )
    end

    ##
    # Get all unique asset type references across all rules.
    #
    # @return [Array<String>] unique asset type names
    #
    # @example
    #   Rule.asset_type_references
    #
    def asset_type_references
      # Extract from when_config and then_config
      names = []
      find_each do |rule|
        names.concat(rule.send(:extract_asset_type_references))
      end
      names.uniq.sort
    end

    ##
    # Build a reference map of rules to their executions.
    #
    # @return [Hash<Rule => Array<RuleExecution>>] reference map
    #
    # @example
    #   Rule.reference_map
    #
    def reference_map
      includes(:rule_executions).group_by(&:itself)
    end

    ##
    # Get rules grouped by enabled status.
    #
    # @return [Hash<Boolean => ActiveRecord::Relation<Rule>>] grouped rules
    #
    # @example
    #   Rule.grouped_by_enabled_status
    #
    def grouped_by_enabled_status
      group_by(&:enabled)
    end
  end
end
