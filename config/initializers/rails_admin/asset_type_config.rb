# RailsAdmin configuration for AssetType model

RailsAdmin.config do |config|
  config.model "AssetType" do
    navigation_label "Assets"
    navigation_icon "fa fa-tags"
    weight 3
    object_label_method :rails_admin_label

    list do
      sort_by :name
      items_per_page 50
      scopes [ :with_assets, nil ]

      field :id
      field :name do
        searchable true
        filterable true
      end
      field :display_name do
        searchable true
      end
      field :description do
        pretty_value do
          bindings[:object].description&.truncate(100)
        end
      end
      field :icon
      field :assets_count do
        label "Assets"
        pretty_value do
          bindings[:object].assets.count
        end
      end
      field :created_at
    end

    edit do
      group :basic_info do
        label "Basic Information"
        field :name do
          required true
          help "Unique identifier (e.g., SolarArray)"
        end
        field :display_name do
          help "Human-readable name (e.g., Solar Array)"
        end
        field :description do
          html_attributes do
            { rows: 4 }
          end
        end
        field :icon do
          help "Icon identifier or class name"
        end
      end
    end

    show do
      group :basic_info do
        label "Basic Information"
        field :id
        field :name
        field :display_name
        field :description
        field :icon
        field :created_at
        field :updated_at
      end

      group :associations do
        label "Associated Assets"
        field :assets do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
        end
        field :assets_count do
          label "Total Assets"
          pretty_value do
            bindings[:object].assets.count
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
