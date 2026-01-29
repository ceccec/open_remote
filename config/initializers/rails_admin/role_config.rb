# RailsAdmin configuration for Role model

RailsAdmin.config do |config|
  config.model "Role" do
    navigation_label "Users & Access"
    navigation_icon "fa fa-key"
    weight 2
    object_label_method :rails_admin_label

    list do
      sort_by :created_at
      # sort_reverse removed due to Rails 8.1 compatibility issue with RailsAdmin
      # Default behavior is reverse order (newest first)
      items_per_page 50

      field :id
      field :name do
        searchable true
        filterable true
      end
      field :resource_type do
        filterable true
      end
      field :resource_id do
        filterable true
      end
      field :users_count do
        label "Users"
        pretty_value do
          bindings[:object].users.count
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
        field :resource_type do
          help "Model class name (e.g., Asset, Rule)"
        end
        field :resource_id do
          help "Specific resource ID (leave blank for global role)"
        end
      end
    end

    show do
      group :basic_info do
        label "Basic Information"
        field :id
        field :name
        field :resource_type
        field :resource_id
        field :created_at
        field :updated_at
      end

      group :users do
        label "Users with this Role"
        field :users do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
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
