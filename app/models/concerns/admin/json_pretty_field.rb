##
# Shared concern for RailsAdmin JSONB field formatting.
# Provides a helper method to configure pretty-printed JSON fields.
#
module Admin
  module JsonPrettyField
    extend ActiveSupport::Concern

    module ClassMethods
      ##
      # Configures a JSONB field to display with pretty-printing.
      #
      # @param field_name [Symbol] the name of the JSONB field
      # @param pretty_method [Symbol, nil] optional method name that returns pretty JSON string
      #   (defaults to "#{field_name}_pretty_json")
      # @return [void]
      def json_pretty_field(field_name, pretty_method: nil)
        pretty_method ||= :"#{field_name}_pretty_json"
        field field_name, :json do
          formatted_value do
            if bindings[:object].respond_to?(pretty_method)
              bindings[:object].public_send(pretty_method)
            else
              JSON.pretty_generate(bindings[:object].public_send(field_name) || {})
            end
          end
        end
      end
    end
  end
end
