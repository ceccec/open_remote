##
# RailsAdmin configuration for DataPoint model.
#
module Admin
  module DataPointAdmin
    extend ActiveSupport::Concern

    included do
      RailsAdmin.config do |config|
        config.model "DataPoint" do
          navigation_label "Data"
          object_label_method do
            "#{asset&.name} - #{attribute_name} (#{timestamp&.strftime('%Y-%m-%d %H:%M')})"
          end

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
      end
    end
  end
end
