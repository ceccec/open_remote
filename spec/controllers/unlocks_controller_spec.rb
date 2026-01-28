require "rails_helper"

RSpec.describe UnlocksController, type: :controller do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  describe "GET #show" do
    context "with valid unlock token and locked account" do
      before do
        user.update_columns(
          locked_at: 1.hour.ago,
          unlock_token: "valid_token"
        )
      end

      it "unlocks the account and redirects to login" do
        get :show, params: { unlock_token: "valid_token" }
        user.reload
        expect(user.locked_at).to be_nil
        expect(user.failed_attempts).to eq(0)
        expect(user.unlock_token).to be_nil
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Your account has been unlocked. You can now log in.")
      end
    end

    context "with invalid unlock token" do
      it "redirects to new unlock path with alert" do
        get :show, params: { unlock_token: "invalid_token" }
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
      end
    end

    context "with valid token but unlocked account" do
      before do
        user.update_columns(
          locked_at: nil,
          unlock_token: "valid_token"
        )
      end

      it "redirects to new unlock path with alert" do
        get :show, params: { unlock_token: "valid_token" }
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
      end
    end

    context "with expired lock" do
      before do
        user.update_columns(
          locked_at: 3.hours.ago,
          unlock_token: "expired_token"
        )
      end

      it "redirects to new unlock path with alert" do
        get :show, params: { unlock_token: "expired_token" }
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
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
    context "with existing locked user" do
      before do
        user.update_columns(locked_at: 1.hour.ago)
      end

      it "sends unlock instructions and redirects" do
        expect(UserMailer).to receive(:unlock_instructions).with(user).and_return(double(deliver_later: true))
        post :create, params: { user: { email: user.email } }
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Unlock instructions have been sent to your email.")
      end
    end

    context "with existing unlocked user" do
      it "redirects without revealing account status" do
        post :create, params: { user: { email: user.email } }
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists and is locked, unlock instructions have been sent.")
      end
    end

    context "with non-existent email" do
      it "redirects without revealing email existence" do
        post :create, params: { user: { email: "nonexistent@example.com" } }
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists and is locked, unlock instructions have been sent.")
      end
    end
  end
end
