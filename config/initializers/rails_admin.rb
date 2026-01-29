# Main RailsAdmin configuration initializer
# Loads modular configuration files from config/initializers/rails_admin/

RailsAdmin.config do |config|
  config.asset_source = :vite

  config.main_app_name = [ "OpenRemote", "API" ]

  # Authentication: check if user is logged in (not role-based)
  config.authenticate_with do
    authenticate_user!
  end
  # Use a lambda to properly access the protected current_user method
  config.current_user_method { current_user }

  # Authorization: role-based permissions via CanCanCan
  # All role checks and permissions are handled in Ability class
  config.authorize_with :cancancan

  # Ensure RailsAdmin inherits from ApplicationController for error handling
  config.parent_controller = "ApplicationController"

  # Auditing via PaperTrail
  config.audit_with :paper_trail, "User", "PaperTrail::Version"

  # Explicit model inclusion (allowlist approach)
  config.included_models = [
    "User",
    "Role",
    "AssetType",
    "Asset",
    "DataPoint",
    "Rule",
    "RuleExecution",
    "Notification"
  ]

  # Object labeling
  config.label_methods << :display_name
  config.label_methods << :email
  config.label_methods << :name
  config.label_methods << :rails_admin_label

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
end

# Load modular configuration files
Dir[Rails.root.join("config/initializers/rails_admin/*.rb")].sort.each do |file|
  require file
end
