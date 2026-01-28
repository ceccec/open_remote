##
# Viewer role ability definitions.
# Grants read-only access to assets, rules, and data.
#
class Ability
  module Viewer
    extend Ability::Base

    module_function

    ##
    # Define permissions for viewer users.
    #
    # @param ability [CanCan::Ability] the ability instance
    # @param user [User] the viewer user
    # @return [void]
    def define(ability, user)
      # Viewers have no access to RailsAdmin
      ability.cannot :access, :rails_admin

      # Viewers can only read assets, rules, and data
      ability.can :read, Asset
      ability.can :read, AssetType
      ability.can :read, Rule
      ability.can :read, RuleExecution
      ability.can :read, DataPoint
      ability.can :read, Notification

      # Viewers cannot manage anything
      ability.cannot :manage, :all
    end
  end
end
