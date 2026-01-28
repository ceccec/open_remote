##
# Base module for ability definitions.
# Provides shared functionality for role-based ability modules.
#
module Ability::Base
  ##
  # Grant RailsAdmin access permissions.
  #
  # @param ability [CanCan::Ability] the ability instance
  # @return [void]
  def grant_rails_admin_access(ability)
    ability.can :access, :rails_admin
    ability.can :read, :dashboard
  end

  ##
  # Grant full management permissions for all models.
  #
  # @param ability [CanCan::Ability] the ability instance
  # @return [void]
  def grant_full_access(ability)
    ability.can :manage, :all
  end

  ##
  # Grant read-only access to specified models.
  #
  # @param ability [CanCan::Ability] the ability instance
  # @param models [Array<Class, Symbol, String>] models to grant read access
  # @return [void]
  def grant_read_access(ability, *models)
    models.each do |model|
      ability.can :read, model
    end
  end

  ##
  # Grant management access to specified models.
  #
  # @param ability [CanCan::Ability] the ability instance
  # @param models [Array<Class, Symbol, String>] models to grant manage access
  # @return [void]
  def grant_manage_access(ability, *models)
    models.each do |model|
      ability.can :manage, model
    end
  end
end
