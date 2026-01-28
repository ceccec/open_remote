require "rails_helper"

RSpec.describe PasswordsController, type: :controller do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  describe "GET #new" do
    it "returns success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with existing user" do
      it "sends reset password instructions and redirects" do
        expect(UserMailer).to receive(:reset_password_instructions).with(user).and_return(double(deliver_later: true))
        post :create, params: { user: { email: user.email } }
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Password reset instructions have been sent to your email.")
      end
    end

    context "with non-existent email" do
      it "redirects without revealing email existence" do
        post :create, params: { user: { email: "nonexistent@example.com" } }
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists with that email, password reset instructions have been sent.")
      end
    end
  end

  describe "GET #edit" do
    context "with valid reset password token" do
      before do
        user.update_columns(
          reset_password_token: "valid_token",
          reset_password_sent_at: 1.hour.ago
        )
      end

      it "returns success" do
        get :edit, params: { reset_password_token: "valid_token" }
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid reset password token" do
      it "redirects to new password path with alert" do
        get :edit, params: { reset_password_token: "invalid_token" }
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
      end
    end

    context "with expired reset password token" do
      before do
        user.update_columns(
          reset_password_token: "expired_token",
          reset_password_sent_at: 7.hours.ago
        )
      end

      it "redirects to new password path with alert" do
        get :edit, params: { reset_password_token: "expired_token" }
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid reset password token" do
      before do
        user.update_columns(
          reset_password_token: "valid_token",
          reset_password_sent_at: 1.hour.ago
        )
      end

      it "resets password and redirects to login" do
        patch :update, params: {
          reset_password_token: "valid_token",
          user: {
            password: "newpassword123",
            password_confirmation: "newpassword123"
          }
        }
        user.reload
        expect(user.reset_password_token).to be_nil
        expect(user.authenticate("newpassword123")).to eq(user)
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Password has been reset successfully.")
      end
    end

    context "with invalid password confirmation" do
      before do
        user.update_columns(
          reset_password_token: "valid_token",
          reset_password_sent_at: 1.hour.ago
        )
      end

      it "returns unprocessable content status" do
        patch :update, params: {
          reset_password_token: "valid_token",
          user: {
            password: "newpassword123",
            password_confirmation: "mismatch"
          }
        }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with invalid reset password token" do
      it "redirects to new password path with alert" do
        patch :update, params: {
          reset_password_token: "invalid_token",
          user: {
            password: "newpassword123",
            password_confirmation: "newpassword123"
          }
        }
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
      end
    end

    context "with expired reset password token" do
      before do
        user.update_columns(
          reset_password_token: "expired_token",
          reset_password_sent_at: 7.hours.ago
        )
      end

      it "redirects to new password path with alert" do
        patch :update, params: {
          reset_password_token: "expired_token",
          user: {
            password: "newpassword123",
            password_confirmation: "newpassword123"
          }
        }
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
      end
    end
  end
end
