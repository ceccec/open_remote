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
      grant_manage_access(
        ability,
        Asset,
        AssetType,
        Rule,
        RuleExecution,
        DataPoint,
        Notification
      )

      # Managers can read but not manage users
      grant_read_access(ability, User)
      ability.cannot :manage, User
    end
  end
end
