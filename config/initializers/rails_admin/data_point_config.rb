# RailsAdmin configuration for DataPoint model

RailsAdmin.config do |config|
  config.model "DataPoint" do
    navigation_label "Data"
    navigation_icon "fa fa-line-chart"
    weight 5
    object_label_method :rails_admin_label

    list do
      sort_by :timestamp
      # sort_reverse removed due to Rails 8.1 compatibility issue with RailsAdmin
      # Default behavior is reverse order (newest first)
      items_per_page 100
      scopes [ :recent, :for_asset, :for_attribute, nil ]

      field :id
      field :asset do
        searchable true
        filterable true
        pretty_value do
          bindings[:object].asset&.name
        end
      end
      field :attribute_name do
        searchable true
        filterable true
      end
      field :reference_path do
        label "Path"
        pretty_value do
          bindings[:object].reference_path
        end
      end
      field :timestamp do
        filterable true
        date_format :default
      end
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
      field :created_at
    end

    edit do
      group :basic_info do
        label "Basic Information"
        field :asset do
          required true
          associated_collection_scope do
            proc { |scope| scope.limit(100) }
          end
        end
        field :attribute_name do
          required true
        end
        field :timestamp do
          required true
          date_format :default
        end
      end

      group :value do
        label "Value Data"
        field :value, :json do
          formatted_value do
            JSON.pretty_generate(bindings[:object].value || {})
          end
          help "JSON object containing the measured value"
        end
      end
    end

    show do
      group :basic_info do
        label "Basic Information"
        field :id
        field :asset do
          pretty_value do
            bindings[:object].asset&.name
          end
        end
        field :attribute_name
        field :timestamp
        field :created_at
        field :updated_at
      end

      group :value do
        label "Value Data"
        field :value, :json do
          formatted_value do
            JSON.pretty_generate(bindings[:object].value || {})
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
        field :asset_type_reference do
          label "Asset Type"
          read_only true
          pretty_value do
            bindings[:object].asset_type_reference&.display_name || bindings[:object].asset_type_reference&.name || "N/A"
          end
        end
        field :related_assets_count do
          label "Related Assets"
          read_only true
          pretty_value do
            bindings[:object].related_assets.count
          end
        end
        field :related_data_points_count do
          label "Related Data Points"
          read_only true
          pretty_value do
            bindings[:object].related_data_points.count
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
