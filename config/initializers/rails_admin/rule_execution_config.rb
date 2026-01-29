# RailsAdmin configuration for RuleExecution model

RailsAdmin.config do |config|
  config.model "RuleExecution" do
    navigation_label "Rules"
    navigation_icon "fa fa-history"
    weight 7
    object_label_method :rails_admin_label

    list do
      sort_by :executed_at
      # sort_reverse removed due to Rails 8.1 compatibility issue with RailsAdmin
      # Default behavior is reverse order (newest first)
      items_per_page 100
      scopes [ :successful, :failed, :skipped, :recent, :with_errors, nil ]

      field :id
      field :rule do
        searchable true
        filterable true
        pretty_value do
          bindings[:object].rule&.name
        end
      end
      field :status do
        filterable true
      end
      field :executed_at do
        filterable true
        date_format :default
      end
      field :error_message do
        pretty_value do
          bindings[:object].error_message&.truncate(80)
        end
      end
    end

    edit do
      group :basic_info do
        label "Basic Information"
        field :rule do
          required true
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
        end
        field :status do
          required true
        end
        field :executed_at do
          required true
          date_format :default
        end
        field :error_message do
          html_attributes do
            { rows: 3 }
          end
        end
      end

      group :result do
        label "Execution Result"
        field :result, :json do
          formatted_value do
            JSON.pretty_generate(bindings[:object].result || {})
          end
          help "JSON object containing execution results"
        end
      end
    end

    show do
      group :basic_info do
        label "Basic Information"
        field :id
        field :rule do
          pretty_value do
            bindings[:object].rule&.name
          end
        end
        field :status
        field :executed_at
        field :error_message
        field :created_at
        field :updated_at
      end

      group :result do
        label "Execution Result"
        field :result, :json do
          formatted_value do
            JSON.pretty_generate(bindings[:object].result || {})
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
