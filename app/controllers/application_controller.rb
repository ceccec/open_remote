##
# Base controller for the application.
# Provides authentication, authorization, and user session management.
#
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Make current_user and logged_in? available in views
  helper_method :current_user, :logged_in?

  # Require authentication by default (can be skipped in specific controllers)
  before_action :authenticate_user!

  protected

  ##
  # Get the current logged-in user.
  # Checks session first, then remember token cookie.
  # Only returns confirmed users.
  #
  # @return [User, nil] the current user or nil if not logged in
  def current_user
    @current_user ||= find_current_user
  end

  ##
  # Find current user from session or remember token.
  # Tries session first, then falls back to remember token cookie.
  # Only returns confirmed users.
  #
  # @return [User, nil] the current user or nil if not found
  def find_current_user
    # Try session first (most common case)
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      return user if user&.confirmed?
    end

    # Try remember token (for "remember me" functionality)
    remember_token = cookies.signed[:remember_token]
    if remember_token
      user = User.find_by_remember_token(remember_token)
      if user&.remember_token_valid? && user.confirmed?
        # Restore session from remember token
        session[:user_id] = user.id
        return user
      else
        # Clean up invalid remember token
        user&.forget_me!
        cookies.delete(:remember_token)
      end
    end

    nil
  end

  ##
  # Check if a user is currently logged in.
  #
  # @return [Boolean] true if user is logged in
  def logged_in?
    current_user.present?
  end

  private

  ##
  # Require user to be authenticated.
  # Redirects to login page if not logged in.
  #
  # @return [void]
  def authenticate_user!
    redirect_to main_app.login_path unless logged_in?
  end

  ##
  # Require user to be an admin.
  # Redirects to login page if not admin.
  #
  # @return [void]
  def require_admin!
    redirect_to main_app.login_path unless current_user&.admin?
  end

  ##
  # Handle CanCan authorization errors.
  # Redirects to root with error message.
  #
  # @param exception [CanCan::AccessDenied] the authorization exception
  # @return [void]
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: exception.message
  end
end
