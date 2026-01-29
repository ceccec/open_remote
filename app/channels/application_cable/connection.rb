##
# Base connection class for Action Cable.
#
# Handles WebSocket connection authentication and authorization.
# Each WebSocket connection is identified by the current user.
#
# @example Connection identification
#   # In channels, you can access the current_user:
#   def subscribed
#     stream_for current_user
#   end
#
# @see https://guides.rubyonrails.org/action_cable_overview.html
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    ##
    # Establish the WebSocket connection.
    # Verifies the user from the session cookie and sets current_user.
    #
    # @raise [ActionCable::Connection::Authorization::UnauthorizedError] if user cannot be verified
    # @return [void]
    def connect
      self.current_user = find_verified_user
    end

    private

    ##
    # Find and verify the user from the session cookie.
    #
    # Rails stores sessions in encrypted cookies by default (CookieStore).
    # The session cookie name is "_session" and contains the full session hash.
    #
    # @return [User] the verified user
    # @raise [ActionCable::Connection::Authorization::UnauthorizedError] if user cannot be verified
    def find_verified_user
      # Access session data from encrypted cookie
      # Rails CookieStore uses "_session" as the default cookie name
      session_data = cookies.encrypted["_session"] || cookies.encrypted[:_session] || {}
      user_id = session_data["user_id"] || session_data[:user_id]

      if user_id && (verified_user = User.find_by(id: user_id))
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
