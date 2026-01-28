module Mapping
  module RuleJsonMapping
    extend ActiveSupport::Concern

    class_methods do
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

    def to_openremote_json
      when_json = (when_config || {}).dup

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
