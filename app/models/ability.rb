##
# Main Ability class for CanCanCan authorization.
# Delegates permission definitions to role-specific modules.
#
# Uses Rolify roles to determine user permissions:
# - Admin: Full access to everything
# - Manager: Can manage assets/rules/data, read-only for users
# - Viewer: Read-only access to assets/rules/data
# - Guest: No access (default)
#
# @example Create ability for admin user
#   user = User.find_by(email: "admin@example.com")
#   ability = Ability.new(user)
#   ability.can?(:manage, :all) # => true
# @example Create ability for manager user
#   user = User.find_by(email: "manager@example.com")
#   user.add_role(:manager)
#   ability = Ability.new(user)
#   ability.can?(:manage, Asset) # => true
#   ability.can?(:manage, User) # => false
# @see spec/models/ability_spec.rb
# @see spec/models/ability_modules_spec.rb
# @see Ability::Admin
# @see Ability::Manager
# @see Ability::Viewer
# @see Ability::Guest
class Ability
  include CanCan::Ability

  ##
  # Initialize abilities for a user based on their role.
  #
  # @param user [User, nil] the user to define abilities for
  # @example Initialize for admin user
  #   admin = User.find_by(email: "admin@example.com")
  #   ability = Ability.new(admin)
  #   ability.can?(:manage, User) # => true
  # @example Initialize for guest (nil user)
  #   ability = Ability.new(nil)
  #   ability.can?(:read, Asset) # => false
  def initialize(user)
    user ||= User.new

    # Determine user role and delegate to appropriate module
    role_module = Ability::RoleDetector.role_for(user)
    role_module.define(self, user)
  end
end
