# RailsAdmin configuration for Asset model

RailsAdmin.config do |config|
  config.model "Asset" do
    navigation_label "Assets"
    navigation_icon "fa fa-cube"
    weight 4
    object_label_method :name

    list do
      sort_by :created_at
      # sort_reverse removed due to Rails 8.1 compatibility issue with RailsAdmin
      # Default behavior is reverse order (newest first)
      items_per_page 50
      scopes [ :root_assets, :with_parent, :solar_arrays, :solar_parks, nil ]

      field :id
      field :name do
        searchable true
        filterable true
      end
      field :asset_type do
        filterable true
        pretty_value do
          bindings[:object].asset_type&.display_name || bindings[:object].asset_type&.name
        end
      end
      field :parent do
        filterable true
        pretty_value do
          bindings[:object].parent&.name || "Root"
        end
      end
      field :reference_path do
        label "Path"
        pretty_value do
          bindings[:object].reference_path
        end
      end
      field :children_count do
        label "Children"
        pretty_value do
          bindings[:object].children.count
        end
      end
      field :data_points_count do
        label "Data Points"
        pretty_value do
          bindings[:object].data_points.count
        end
      end
      field :notifications_count do
        label "Notifications"
        pretty_value do
          bindings[:object].notifications.count
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
        field :asset_type do
          required true
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
        end
        field :parent do
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
          help "Leave blank for root asset"
        end
      end

      group :attributes do
        label "Attributes Data"
        field :attributes_data, :json do
          formatted_value do
            bindings[:object].attributes_data_pretty_json
          end
          help "JSON object containing flexible attribute data"
        end
      end
    end

    show do
      group :basic_info do
        label "Basic Information"
        field :id
        field :name
        field :asset_type do
          pretty_value do
            bindings[:object].asset_type&.display_name || bindings[:object].asset_type&.name
          end
        end
        field :parent do
          pretty_value do
            bindings[:object].parent&.name || "Root Asset"
          end
        end
        field :children do
          associated_collection_scope do
            proc { |scope| scope.limit(50) }
          end
        end
        field :created_at
        field :updated_at
      end

      group :attributes do
        label "Attributes Data"
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

      group :references do
        label "Reference Information"
        field :reference_path do
          read_only true
          pretty_value do
            bindings[:object].reference_path
          end
        end
        field :reference_chain do
          read_only true
          pretty_value do
            bindings[:object].reference_chain.join(" > ")
          end
        end
        field :root_reference do
          read_only true
          pretty_value do
            bindings[:object].root_reference&.name || "N/A"
          end
        end
        field :all_descendants_count do
          label "Total Descendants"
          read_only true
          pretty_value do
            bindings[:object].all_descendants.count
          end
        end
        field :all_ancestors_count do
          label "Total Ancestors"
          read_only true
          pretty_value do
            bindings[:object].all_ancestors.count
          end
        end
      end

      group :associations do
        label "Associations"
        field :data_points do
          associated_collection_scope do
            proc { |scope| scope.recent.limit(50) }
          end
        end
        field :data_points_count do
          label "Total Data Points"
          pretty_value do
            bindings[:object].data_points.count
          end
        end
        field :notifications do
          associated_collection_scope do
            proc { |scope| scope.recent.limit(50) }
          end
        end
        field :notifications_count do
          label "Total Notifications"
          pretty_value do
            bindings[:object].notifications.count
          end
        end
      end

      group :methods do
        label "Export Methods"
        field :to_openremote_json_tree do
          read_only true
          formatted_value do
            JSON.pretty_generate(bindings[:object].to_openremote_json_tree)
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
