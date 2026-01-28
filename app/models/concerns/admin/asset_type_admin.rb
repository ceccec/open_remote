##
# RailsAdmin configuration for AssetType model.
#
module Admin
  module AssetTypeAdmin
    extend ActiveSupport::Concern

    included do
      RailsAdmin.config do |config|
        config.model "AssetType" do
          navigation_label "Assets"
          object_label_method do
            display_name.presence || name
          end

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
      end
    end
  end
end
