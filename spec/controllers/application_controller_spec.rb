require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  let!(:user) do
    User.create!(
      email: "admin@example.com",
      password: "password123",
      admin: true
    )
  end

  describe "#current_user and #logged_in?" do
    it "returns nil and false when there is no user in the session" do
      get :index
      expect(controller.send(:current_user)).to be_nil
      expect(controller.send(:logged_in?)).to be(false)
    end

    it "returns the user and true when a user id is stored in the session" do
      session[:user_id] = user.id
      get :index
      expect(controller.send(:current_user)).to eq(user)
      expect(controller.send(:logged_in?)).to be(true)
    end
  end

  describe "#authenticate_user!" do
    controller do
      before_action :authenticate_user!

      def index
        head :ok
      end
    end

    it "redirects to login when not logged in" do
      get :index
      expect(response).to redirect_to("/login")
    end

    it "allows request when logged in" do
      session[:user_id] = user.id
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "#require_admin!" do
    controller do
      before_action :require_admin!

      def index
        head :ok
      end
    end

    it "redirects to login when current_user is not an admin" do
      non_admin = User.create!(
        email: "user@example.com",
        password: "password123",
        admin: false
      )
      session[:user_id] = non_admin.id

      get :index
      expect(response).to redirect_to("/login")
    end

    it "allows request when current_user is an admin" do
      session[:user_id] = user.id
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "CanCan::AccessDenied rescue" do
    controller do
      def index
        raise CanCan::AccessDenied.new("Not authorized", :read, User)
      end
    end

    it "redirects to root with error message" do
      session[:user_id] = user.id
      get :index
      expect(response).to redirect_to("/")
      expect(flash[:alert]).to eq("Not authorized")
    end
  end
end
