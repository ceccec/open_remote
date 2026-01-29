# RailsAdmin configuration for User model

RailsAdmin.config do |config|
  config.model "User" do
    navigation_label "Users & Access"
    navigation_icon "fa fa-users"
    weight 1
    object_label_method :email

    list do
      sort_by :created_at
      # sort_reverse removed due to Rails 8.1 compatibility issue with RailsAdmin
      # Default behavior is reverse order (newest first)
      items_per_page 50

      field :id
      field :email do
        searchable true
        filterable true
      end
      field :admin do
        filterable true
      end
      field :confirmed_at do
        label "Confirmed"
        pretty_value do
          bindings[:object].confirmed_at ? "Yes" : "No"
        end
      end
      field :roles do
        pretty_value do
          bindings[:object].roles.pluck(:name).join(", ") || "None"
        end
      end
      field :created_at
      field :updated_at
    end

    edit do
      group :basic_info do
        label "Basic Information"
        field :email do
          required true
        end
        field :password do
          required false
          help "Leave blank to keep current password"
        end
        field :password_confirmation do
          required false
        end
        field :admin do
          help "Grant admin privileges"
        end
      end

      group :authentication do
        label "Authentication Status"
        field :confirmed_at do
          read_only true
        end
        field :locked_at do
          read_only true
        end
        field :failed_attempts do
          read_only true
        end
      end

      group :roles do
        label "Roles & Permissions"
        field :roles do
          associated_collection_scope do
            proc { |scope| scope }
          end
        end
      end
    end

    show do
      group :basic_info do
        label "Basic Information"
        field :id
        field :email
        field :admin
        field :created_at
        field :updated_at
      end

      group :authentication do
        label "Authentication Status"
        field :confirmed_at
        field :confirmation_sent_at
        field :locked_at
        field :failed_attempts
        field :remember_created_at
      end

      group :roles do
        label "Roles & Permissions"
        field :roles do
          pretty_value do
            bindings[:object].roles.map(&:rails_admin_label).join(", ") || "None"
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
