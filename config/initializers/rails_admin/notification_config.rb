# RailsAdmin configuration for Notification model

RailsAdmin.config do |config|
  config.model "Notification" do
    navigation_label "System"
    navigation_icon "fa fa-bell"
    weight 8
    object_label_method :rails_admin_label

    list do
      sort_by :sent_at
      # sort_reverse removed due to Rails 8.1 compatibility issue with RailsAdmin
      # Default behavior is reverse order (newest first)
      items_per_page 100
      scopes [ :unacknowledged, :acknowledged, :info, :warning, :error, :recent, nil ]

      field :id
      field :message do
        searchable true
        pretty_value do
          bindings[:object].message&.truncate(60)
        end
      end
      field :severity do
        filterable true
      end
      field :sent_at do
        filterable true
        date_format :default
      end
      field :acknowledged_at do
        filterable true
        date_format :default
      end
      field :asset do
        filterable true
        pretty_value do
          bindings[:object].asset&.name
        end
      end
      field :rule do
        filterable true
        pretty_value do
          bindings[:object].rule&.name
        end
      end
    end

    edit do
      group :basic_info do
        label "Basic Information"
        field :message do
          required true
          html_attributes do
            { rows: 3 }
          end
        end
        field :severity do
          required true
        end
        field :sent_at do
          required true
          date_format :default
        end
        field :acknowledged_at do
          date_format :default
          help "Set to acknowledge notification"
        end
      end

      group :associations do
        label "Associations"
        field :asset do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
          help "Optional associated asset"
        end
        field :rule do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
          help "Optional associated rule"
        end
      end
    end

    show do
      group :basic_info do
        label "Basic Information"
        field :id
        field :message
        field :severity
        field :sent_at
        field :acknowledged_at
        field :created_at
        field :updated_at
      end

      group :associations do
        label "Associations"
        field :asset do
          pretty_value do
            bindings[:object].asset&.name || "N/A"
          end
        end
        field :rule do
          pretty_value do
            bindings[:object].rule&.name || "N/A"
          end
        end
      end

      group :references do
        label "Reference Information"
        field :reference_path do
          read_only true
          pretty_value do
            bindings[:object].reference_path if bindings[:object].respond_to?(:reference_path)
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
