RailsAdmin.config do |config|
  config.asset_source = :vite

  config.main_app_name = [ "OpenRemote", "Admin" ]

  # Authentication: check if user is logged in (not role-based)
  config.authenticate_with do
    authenticate_user!
  end
  # Use a lambda to properly access the protected current_user method
  config.current_user_method { current_user }

  # Authorization: role-based permissions via CanCanCan
  # All role checks and permissions are handled in Ability class
  config.authorize_with :cancancan

  # Ensure RailsAdmin inherits from ApplicationController for error handling
  config.parent_controller = "ApplicationController"

  # Auditing via PaperTrail
  config.audit_with :paper_trail, "User", "PaperTrail::Version"

  # Explicit model inclusion (allowlist approach)
  config.included_models = [
    "User",
    "AssetType",
    "Asset",
    "DataPoint",
    "Rule",
    "RuleExecution",
    "Notification"
  ]

  # Object labeling
  config.label_methods << :display_name
  config.label_methods << :email

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  # User model configuration
  config.model "User" do
    navigation_label "Users & Access"
    object_label_method :email

    list do
      field :email
      field :admin
      field :created_at
      field :updated_at
    end

    edit do
      field :email
      field :password
      field :admin
    end

    show do
      field :id
      field :email
      field :admin
      field :created_at
      field :updated_at
    end
  end

  # AssetType model configuration
  config.model "AssetType" do
    navigation_label "Assets"
    object_label_method :rails_admin_label

    list do
      scopes [ :with_assets, nil ]

      field :name
      field :display_name
      field :description
      field :assets_count do
        pretty_value do
          bindings[:object].assets.count
        end
      end
      field :created_at
    end

    edit do
      group :basic_info do
        field :name
        field :display_name
        field :description
        field :icon
      end
    end

    show do
      group :basic_info do
        field :id
        field :name
        field :display_name
        field :description
        field :icon
      end

      group :associations do
        field :assets do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
        end
      end

      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end

  # Asset model configuration
  config.model "Asset" do
    navigation_label "Assets"
    object_label_method :name

    list do
      scopes [ :root_assets, :with_parent, :solar_arrays, :solar_parks, nil ]

      field :name
      field :asset_type do
        pretty_value do
          bindings[:object].asset_type&.display_name || bindings[:object].asset_type&.name
        end
      end
      field :parent do
        pretty_value do
          bindings[:object].parent&.name || "Root"
        end
      end
      field :children_count do
        pretty_value do
          bindings[:object].children.count
        end
      end
      field :data_points_count do
        pretty_value do
          bindings[:object].data_points.count
        end
      end
      field :created_at
    end

    edit do
      group :basic_info do
        field :name
        field :asset_type do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
        end
        field :parent do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
        end
      end

      group :attributes do
        field :attributes_data, :json do
          formatted_value do
            bindings[:object].attributes_data_pretty_json
          end
        end
      end
    end

    show do
      group :basic_info do
        field :id
        field :name
        field :asset_type do
          pretty_value do
            bindings[:object].asset_type&.display_name || bindings[:object].asset_type&.name
          end
        end
        field :parent do
          pretty_value do
            bindings[:object].parent&.name
          end
        end
        field :children
      end

      group :attributes do
        field :attributes_data, :json do
          formatted_value do
            bindings[:object].attributes_data_pretty_json
          end
        end
        field :attributes_data_pretty_json do
          read_only true
          formatted_value do
            bindings[:object].attributes_data_pretty_json
          end
        end
      end

      group :associations do
        field :data_points do
          associated_collection_scope do
            proc { |scope| scope.recent.limit(50) }
          end
        end
        field :notifications do
          associated_collection_scope do
            proc { |scope| scope.recent.limit(50) }
          end
        end
      end

      group :methods do
        field :to_openremote_json_tree do
          read_only true
          formatted_value do
            JSON.pretty_generate(bindings[:object].to_openremote_json_tree)
          end
        end
      end

      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end

  # DataPoint model configuration
  config.model "DataPoint" do
    navigation_label "Data"
    object_label_method :rails_admin_label

    list do
      scopes [ :recent, nil ]

      field :asset do
        pretty_value do
          bindings[:object].asset&.name
        end
      end
      field :attribute_name
      field :timestamp
      field :value do
        formatted_value do
          val = bindings[:object].value
          if val.is_a?(Hash) && val["value"]
            val["value"].to_s
          else
            JSON.pretty_generate(val || {})
          end
        end
      end
    end

    edit do
      group :basic_info do
        field :asset do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
        end
        field :attribute_name
        field :timestamp
      end

      group :value do
        field :value, :json do
          formatted_value do
            JSON.pretty_generate(bindings[:object].value || {})
          end
        end
      end
    end

    show do
      group :basic_info do
        field :id
        field :asset do
          pretty_value do
            bindings[:object].asset&.name
          end
        end
        field :attribute_name
        field :timestamp
      end

      group :value do
        field :value, :json do
          formatted_value do
            JSON.pretty_generate(bindings[:object].value || {})
          end
        end
      end

      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end

  # Rule model configuration
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

  # RuleExecution model configuration
  config.model "RuleExecution" do
    navigation_label "Rules"
    object_label_method :rails_admin_label

    list do
      scopes [ :successful, :failed, :skipped, :recent, :with_errors, nil ]

      field :rule do
        pretty_value do
          bindings[:object].rule&.name
        end
      end
      field :status
      field :executed_at
      field :error_message do
        pretty_value do
          bindings[:object].error_message&.truncate(80)
        end
      end
    end

    show do
      group :basic_info do
        field :id
        field :rule do
          pretty_value do
            bindings[:object].rule&.name
          end
        end
        field :status
        field :executed_at
        field :error_message
      end

      group :result do
        field :result, :json do
          formatted_value do
            JSON.pretty_generate(bindings[:object].result || {})
          end
        end
      end

      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end

  # Notification model configuration
  config.model "Notification" do
    navigation_label "System"
    object_label_method :rails_admin_label

    list do
      scopes [ :unacknowledged, :acknowledged, :info, :warning, :error, :recent, nil ]

      field :message do
        pretty_value do
          bindings[:object].message&.truncate(60)
        end
      end
      field :severity
      field :sent_at
      field :acknowledged_at
      field :asset do
        pretty_value do
          bindings[:object].asset&.name
        end
      end
      field :rule do
        pretty_value do
          bindings[:object].rule&.name
        end
      end
    end

    show do
      group :basic_info do
        field :id
        field :message
        field :severity
        field :sent_at
        field :acknowledged_at
      end

      group :associations do
        field :asset do
          pretty_value do
            bindings[:object].asset&.name
          end
        end
        field :rule do
          pretty_value do
            bindings[:object].rule&.name
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
