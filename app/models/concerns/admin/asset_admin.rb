##
# RailsAdmin configuration for Asset model.
#
module Admin
  module AssetAdmin
    extend ActiveSupport::Concern

    included do
      RailsAdmin.config do |config|
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
      end
    end
  end
end
