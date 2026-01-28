##
# Manager role ability definitions.
# Grants management access to assets, rules, and data, but not user management.
#
class Ability
  module Manager
    extend Ability::Base

    module_function

    ##
    # Define permissions for manager users.
    #
    # @param ability [CanCan::Ability] the ability instance
    # @param user [User] the manager user
    # @return [void]
    def define(ability, user)
      grant_rails_admin_access(ability)

      # Managers can manage assets, rules, data points, and notifications
      ability.can :manage, Asset
      ability.can :manage, AssetType
      ability.can :manage, Rule
      ability.can :manage, RuleExecution
      ability.can :manage, DataPoint
      ability.can :manage, Notification

      # Managers can read but not manage users
      ability.can :read, User
      ability.cannot :manage, User
    end
  end
end
