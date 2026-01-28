##
# RailsAdmin configuration for Rule model.
#
module Admin
  module RuleAdmin
    extend ActiveSupport::Concern

    included do
      RailsAdmin.config do |config|
        config.model "Rule" do
          navigation_label "Rules"
          object_label_method :name

          list do
            scopes [ :enabled, :disabled, :scheduled, :attribute_value, :attribute_changed, :with_failed_executions, nil ]

            field :name
            field :enabled
            field :schedule
            field :timezone
            field :rule_executions do
              pretty_value do
                bindings[:object].rule_executions.count
              end
            end
            field :last_execution do
              pretty_value do
                last_exec = bindings[:object].rule_executions.order(executed_at: :desc).first
                last_exec ? "#{last_exec.status} (#{last_exec.executed_at.strftime('%Y-%m-%d %H:%M')})" : "Never"
              end
            end
            field :created_at
          end

          edit do
            group :basic_info do
              field :name
              field :description
              field :enabled
              field :schedule
              field :timezone
            end

            group :configuration do
              field :when_config, :json do
                formatted_value do
                  bindings[:object].when_config_pretty_json
                end
              end
              field :then_config, :json do
                formatted_value do
                  bindings[:object].then_config_pretty_json
                end
              end
            end
          end

          show do
            group :basic_info do
              field :id
              field :name
              field :description
              field :enabled
              field :schedule
              field :timezone
            end

            group :configuration do
              field :when_config, :json do
                formatted_value do
                  bindings[:object].when_config_pretty_json
                end
              end
              field :then_config, :json do
                formatted_value do
                  bindings[:object].then_config_pretty_json
                end
              end
              field :when_config_pretty_json do
                read_only true
                formatted_value do
                  bindings[:object].when_config_pretty_json
                end
              end
              field :then_config_pretty_json do
                read_only true
                formatted_value do
                  bindings[:object].then_config_pretty_json
                end
              end
            end

            group :executions do
              field :rule_executions do
                associated_collection_scope do
                  proc { |scope| scope.recent.limit(50) }
                end
              end
              field :last_execution_status do
                pretty_value do
                  last_exec = bindings[:object].rule_executions.order(executed_at: :desc).first
                  last_exec ? last_exec.status : "Never executed"
                end
              end
              field :last_execution_time do
                pretty_value do
                  last_exec = bindings[:object].rule_executions.order(executed_at: :desc).first
                  last_exec ? last_exec.executed_at.strftime("%Y-%m-%d %H:%M:%S") : "N/A"
                end
              end
              field :execution_count do
                pretty_value do
                  bindings[:object].rule_executions.count
                end
              end
              field :failed_execution_count do
                pretty_value do
                  bindings[:object].rule_executions.failed.count
                end
              end
            end

            group :methods do
              field :to_openremote_json do
                read_only true
                formatted_value do
                  JSON.pretty_generate(bindings[:object].to_openremote_json)
                end
              end
            end

            group :audit do
              field :created_at
              field :updated_at
            end
          end
        end
      end
    end
  end
end
