##
# RailsAdmin configuration for Notification model.
#
module Admin
  module NotificationAdmin
    extend ActiveSupport::Concern

    included do
      RailsAdmin.config do |config|
        config.model "Notification" do
          navigation_label "System"
          object_label_method do
            parts = [ message&.truncate(50) ]
            parts << "(#{severity})" if severity.present?
            parts << asset&.name if asset.present?
            parts << rule&.name if rule.present?
            parts.join(" - ")
          end

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
    end
  end
end
