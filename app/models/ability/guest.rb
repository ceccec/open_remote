##
# Guest role ability definitions.
# No access to RailsAdmin or models by default.
#
class Ability
  module Guest
    extend Ability::Base

    module_function

    ##
    # Define permissions for guest users (non-authenticated or non-admin).
    #
    # @param ability [CanCan::Ability] the ability instance
    # @param user [User, nil] the guest user (may be nil)
    # @return [void]
    def define(ability, _user)
      # Guests have no access to RailsAdmin or models by default
      ability.cannot :manage, :all
      ability.cannot :access, :rails_admin
    end
  end
end
