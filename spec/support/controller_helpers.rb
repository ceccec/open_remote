module ControllerHelpers
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
end
