##
# Shared concern for RailsAdmin models with audit fields.
# Provides a helper method to add standard audit field groups.
#
module Admin
  module AuditedModel
    extend ActiveSupport::Concern

    module ClassMethods
      ##
      # Adds an audit group with created_at and updated_at fields.
      #
      # @return [void]
      def audit_group
        group :audit do
          field :created_at
          field :updated_at
        end
      end
    end
  end
end
