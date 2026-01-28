require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      admin: true
    )
  end

  describe "GET #new" do
    it "returns success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "creates a session and redirects" do
        post :create, params: { email: user.email, password: "password123" }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "with invalid credentials" do
      it "does not create a session" do
        post :create, params: { email: user.email, password: "wrongpassword" }
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "with non-existent user" do
      it "does not create a session" do
        post :create, params: { email: "nonexistent@example.com", password: "password123" }
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      session[:user_id] = user.id
    end

    it "destroys the session and redirects" do
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:redirect)
    end
  end
end
