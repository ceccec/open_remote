##
# Role detection logic for determining user roles.
# Uses Rolify roles to determine permissions.
#
module Ability::RoleDetector
  ##
  # Determine which role module should handle permissions for a user.
  #
  # @param user [User, nil] the user to check
  # @return [Module] the role module (Ability::Admin, Ability::Manager, Ability::Viewer, Ability::Guest, etc.)
  def self.role_for(user)
    return Ability::Guest unless user

    # Check for admin role (backward compatible with admin flag or admin role)
    return Ability::Admin if user.admin?

    # Check for manager role
    return Ability::Manager if user.has_role?(:manager)

    # Check for viewer role
    return Ability::Viewer if user.has_role?(:viewer)

    # Default to guest
    Ability::Guest
  end
end
