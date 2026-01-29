##
# Provides JSON import/export functionality for Rule model in OpenRemote format.
#
# This concern enables rules to be imported from and exported to OpenRemote's
# JSON format, preserving rule configuration including conditions, actions,
# schedules, and timezone settings.
#
# @example Importing a rule from JSON
#   json_data = {
#     "name" => "Temperature Alert",
#     "enabled" => true,
#     "when" => { "condition" => "Schedule", "schedule" => "0 * * * *" },
#     "then" => [{ "action" => "Send notification", "message" => "Check temperature" }]
#   }
#   Rule.from_openremote_json(json_data)
#
# @example Exporting a rule to JSON
#   rule = Rule.find_by(name: "Temperature Alert")
#   json = rule.to_openremote_json
#
module Mapping
  module RuleJsonMapping
    extend ActiveSupport::Concern
    extend ConcernFeatures

    # Concern features - enables Rule interaction with OpenRemote JSON format
    concern_feature :provides, :from_openremote_json, :to_openremote_json
    enables_interaction :json_import_export, [ :Rule ], "Enables Rule to import/export from OpenRemote JSON format"

    class_methods do
      ##
      # Import a rule from OpenRemote JSON format.
      #
      # Creates or updates a rule based on the JSON node structure.
      # Validations are skipped during import to allow flexible testing scenarios.
      #
      # @param node [Hash] JSON node with "name", "enabled", "when", and "then" keys
      # @return [Rule] the created or updated rule
      # @example
      #   json = {
      #     "name" => "Alert Rule",
      #     "enabled" => true,
      #     "when" => { "condition" => "Schedule", "schedule" => "0 * * * *" },
      #     "then" => []
      #   }
      #   Rule.from_openremote_json(json)
      def from_openremote_json(node)
        rule = find_or_initialize_by(name: node["name"])
        rule.description = node["description"]
        rule.enabled = node.fetch("enabled", true)

        when_config = node["when"] || {}
        rule.when_config = when_config
        rule.then_config = node["then"] || []

        # Extract schedule and timezone from when config
        rule.schedule = when_config["schedule"]
        rule.timezone = when_config.fetch("timezone", "UTC")

        # Skip validations during import to allow empty configs for testing
        rule.save!(validate: false)
        rule
      end
    end

    ##
    # Export rule to OpenRemote JSON format.
    #
    # Converts the rule to a JSON-compatible hash structure that matches
    # the OpenRemote format. Includes schedule and timezone in the "when"
    # configuration if they differ from defaults.
    #
    # @return [Hash] JSON-compatible hash with "name", "description", "enabled", "when", and "then" keys
    # @example
    #   rule = Rule.find_by(name: "Temperature Alert")
    #   json = rule.to_openremote_json
    #   JSON.pretty_generate(json)
    def to_openremote_json
      when_json = (when_config || {}).deep_dup

      # Include schedule and timezone if they're set
      # But if when_config is empty and schedule/timezone are defaults, keep it empty
      if when_json.empty? && schedule.blank? && (timezone.blank? || timezone == "UTC")
        # Keep when_json empty
      else
        when_json["schedule"] = schedule if schedule.present?
        when_json["timezone"] = timezone if timezone.present? && timezone != "UTC"
      end

      {
        "name" => name,
        "description" => description,
        "enabled" => enabled,
        "when" => when_json,
        "then" => then_config || []
      }
    end
  end
end
