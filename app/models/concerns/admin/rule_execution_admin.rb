##
# RailsAdmin configuration for RuleExecution model.
#
module Admin
  module RuleExecutionAdmin
    extend ActiveSupport::Concern

    included do
      RailsAdmin.config do |config|
        config.model "RuleExecution" do
          navigation_label "Rules"
          object_label_method do
            "#{rule&.name} - #{status} (#{executed_at&.strftime('%Y-%m-%d %H:%M')})"
          end

          list do
            scopes [ :successful, :failed, :skipped, :recent, :with_errors, nil ]

            field :rule do
              pretty_value do
                bindings[:object].rule&.name
              end
            end
            field :status
            field :executed_at
            field :error_message do
              pretty_value do
                bindings[:object].error_message&.truncate(80)
              end
            end
          end

          show do
            group :basic_info do
              field :id
              field :rule do
                pretty_value do
                  bindings[:object].rule&.name
                end
              end
              field :status
              field :executed_at
              field :error_message
            end

            group :result do
              field :result, :json do
                formatted_value do
                  JSON.pretty_generate(bindings[:object].result || {})
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
