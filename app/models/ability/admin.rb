##
# Admin role ability definitions.
# Grants full access to RailsAdmin and all models, including user and role management.
#
class Ability
  module Admin
    extend Ability::Base

    module_function

    ##
    # Define permissions for admin users.
    #
    # @param ability [CanCan::Ability] the ability instance
    # @param user [User] the admin user
    # @return [void]
    def define(ability, user)
      grant_rails_admin_access(ability)
      grant_full_access(ability)

      # Admins can manage users and roles
      ability.can :manage, User
      ability.can :manage, Role
    end
  end
end
