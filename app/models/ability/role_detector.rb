##
# Role detection logic for determining user roles.
#
module Ability::RoleDetector
  ##
  # Determine which role module should handle permissions for a user.
  #
  # @param user [User, nil] the user to check
  # @return [Module] the role module (Ability::Admin, Ability::Guest, etc.)
  def self.role_for(user)
    return Ability::Guest unless user

    # Check for admin role
    return Ability::Admin if user.respond_to?(:admin?) && user.admin?

    # Default to guest
    Ability::Guest
  end
end
