class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  protected

  # Protected so RailsAdmin controllers (which inherit from ApplicationController) can access it
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  private

  def authenticate_user!
    redirect_to main_app.login_path unless logged_in?
  end

  def require_admin!
    redirect_to main_app.login_path unless current_user&.admin?
  end

  # Handle CanCan authorization errors
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: exception.message
  end
end
