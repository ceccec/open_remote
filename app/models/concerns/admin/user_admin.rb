##
# RailsAdmin configuration for User model.
#
module Admin
  module UserAdmin
    extend ActiveSupport::Concern

    included do
      RailsAdmin.config do |config|
        config.model "User" do
          navigation_label "Users & Access"
          object_label_method :email

          list do
            field :email
            field :admin
            field :created_at
            field :updated_at
          end

          edit do
            field :email
            field :password
            field :admin
          end

          show do
            field :id
            field :email
            field :admin
            field :created_at
            field :updated_at
          end
        end
      end
    end
  end
end
