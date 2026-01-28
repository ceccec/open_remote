require "rails_helper"

RSpec.describe ConfirmationsController, type: :controller do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  describe "GET #show" do
    context "with valid confirmation token" do
      before do
        user.update_columns(
          confirmation_token: "valid_token",
          confirmation_sent_at: 1.hour.ago
        )
      end

      it "confirms the user and redirects to login" do
        get :show, params: { confirmation_token: "valid_token" }
        user.reload
        expect(user.confirmed?).to be(true)
        expect(user.confirmation_token).to be_nil
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Your email has been confirmed. You can now log in.")
      end
    end

    context "with invalid confirmation token" do
      it "redirects to new confirmation path with alert" do
        get :show, params: { confirmation_token: "invalid_token" }
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
      end
    end

    context "with expired confirmation token" do
      before do
        user.update_columns(
          confirmation_token: "expired_token",
          confirmation_sent_at: 25.hours.ago
        )
      end

      it "redirects to new confirmation path with alert" do
        get :show, params: { confirmation_token: "expired_token" }
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
      end
    end

    context "with already confirmed user" do
      before do
        user.update_columns(
          confirmed_at: 1.day.ago,
          confirmation_token: "old_token"
        )
      end

      it "redirects to new confirmation path with alert" do
        get :show, params: { confirmation_token: "old_token" }
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
      end
    end
  end

  describe "GET #new" do
    it "returns success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with existing unconfirmed user" do
      before do
        user.update_columns(confirmed_at: nil)
      end

      it "sends confirmation instructions and redirects" do
        expect(UserMailer).to receive(:confirmation_instructions).with(user).and_return(double(deliver_later: true))
        post :create, params: { user: { email: user.email } }
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Confirmation instructions have been sent to your email.")
      end
    end

    context "with existing confirmed user" do
      before do
        user.update_columns(confirmed_at: 1.day.ago)
      end

      it "redirects to login with notice" do
        post :create, params: { user: { email: user.email } }
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Email already confirmed. You can log in.")
      end
    end

    context "with non-existent email" do
      it "redirects to login without revealing email existence" do
        post :create, params: { user: { email: "nonexistent@example.com" } }
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists with that email, confirmation instructions have been sent.")
      end
    end
  end
end
