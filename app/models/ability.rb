##
# Main Ability class for CanCanCan authorization.
# Delegates permission definitions to role-specific modules.
#
class Ability
  include CanCan::Ability

  ##
  # Initialize abilities for a user based on their role.
  #
  # @param user [User, nil] the user to define abilities for
  def initialize(user)
    user ||= User.new

    # Determine user role and delegate to appropriate module
    role_module = Ability::RoleDetector.role_for(user)
    role_module.define(self, user)
  end
end
