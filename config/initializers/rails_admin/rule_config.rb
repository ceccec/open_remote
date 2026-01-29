# RailsAdmin configuration for Rule model

RailsAdmin.config do |config|
  config.model "Rule" do
    navigation_label "Rules"
    navigation_icon "fa fa-cogs"
    weight 6
    object_label_method :name

    list do
      sort_by :created_at
      # sort_reverse removed due to Rails 8.1 compatibility issue with RailsAdmin
      # Default behavior is reverse order (newest first)
      items_per_page 50
      scopes [ :enabled, :disabled, :scheduled, :attribute_value, :attribute_changed, :with_failed_executions, nil ]

      field :id
      field :name do
        searchable true
        filterable true
      end
      field :enabled do
        filterable true
      end
      field :schedule do
        filterable true
      end
      field :timezone
      field :rule_executions_count do
        label "Executions"
        pretty_value do
          bindings[:object].rule_executions.count
        end
      end
      field :last_execution do
        label "Last Execution"
        pretty_value do
          last_exec = bindings[:object].rule_executions.order(executed_at: :desc).first
          last_exec ? "#{last_exec.status} (#{last_exec.executed_at.strftime('%Y-%m-%d %H:%M')})" : "Never"
        end
      end
      field :created_at
    end

    edit do
      group :basic_info do
        label "Basic Information"
        field :name do
          required true
        end
        field :description do
          html_attributes do
            { rows: 3 }
          end
        end
        field :enabled do
          help "Enable or disable rule execution"
        end
        field :schedule do
          help "Cron expression or schedule pattern"
        end
        field :timezone do
          help "Timezone for schedule-based rules"
        end
      end

      group :configuration do
        label "Rule Configuration"
        field :when_config, :json do
          formatted_value do
            bindings[:object].when_config_pretty_json
          end
          help "Condition configuration (when to trigger)"
        end
        field :then_config, :json do
          formatted_value do
            bindings[:object].then_config_pretty_json
          end
          help "Action configuration (what to do)"
        end
      end
    end

    show do
      group :basic_info do
        label "Basic Information"
        field :id
        field :name
        field :description
        field :enabled
        field :schedule
        field :timezone
        field :created_at
        field :updated_at
      end

      group :configuration do
        label "Rule Configuration"
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
        label "Execution History"
        field :rule_executions do
          associated_collection_scope do
            proc { |scope| scope.recent.limit(50) }
          end
        end
        field :execution_count do
          label "Total Executions"
          pretty_value do
            bindings[:object].rule_executions.count
          end
        end
        field :last_execution_status do
          label "Last Status"
          pretty_value do
            last_exec = bindings[:object].rule_executions.order(executed_at: :desc).first
            last_exec ? last_exec.status : "Never executed"
          end
        end
        field :last_execution_time do
          label "Last Execution Time"
          pretty_value do
            last_exec = bindings[:object].rule_executions.order(executed_at: :desc).first
            last_exec ? last_exec.executed_at.strftime("%Y-%m-%d %H:%M:%S") : "N/A"
          end
        end
        field :failed_execution_count do
          label "Failed Executions"
          pretty_value do
            bindings[:object].rule_executions.failed.count
          end
        end
      end

      group :references do
        label "Reference Information"
        field :reference_path do
          read_only true
          pretty_value do
            bindings[:object].reference_path
          end
        end
        field :referenced_assets_count do
          label "Referenced Assets"
          read_only true
          pretty_value do
            bindings[:object].referenced_assets.count
          end
        end
        field :referenced_asset_types do
          label "Referenced Asset Types"
          read_only true
          pretty_value do
            bindings[:object].referenced_asset_types.pluck(:name).join(", ") || "None"
          end
        end
      end

      group :methods do
        label "Export Methods"
        field :to_openremote_json do
          read_only true
          formatted_value do
            JSON.pretty_generate(bindings[:object].to_openremote_json)
          end
        end
      end

      group :audit do
        label "Audit Trail"
        field :created_at
        field :updated_at
      end
    end
  end
end
