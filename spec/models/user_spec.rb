require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123",
        admin: false
      )
      expect(user).to be_valid
    end

    it "is invalid without email" do
      user = User.new(email: nil, password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with duplicate email" do
      User.create!(email: "test@example.com", password: "password123")
      user = User.new(email: "test@example.com", password: "password123")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "is invalid with invalid email format" do
      user = User.new(email: "invalid-email", password: "password123")
      expect(user).not_to be_valid
    end

    it "is invalid with password shorter than 6 characters" do
      user = User.new(email: "test@example.com", password: "short")
      expect(user).not_to be_valid
    end
  end

  describe "has_secure_password" do
    it "authenticates with correct password" do
      user = User.create!(
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
      expect(user.authenticate("password123")).to eq(user)
    end

    it "does not authenticate with incorrect password" do
      user = User.create!(
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
      expect(user.authenticate("wrongpassword")).to be_falsey
    end
  end

  describe "admin flag" do
    it "defaults to false" do
      user = User.create!(
        email: "test@example.com",
        password: "password123"
      )
      expect(user.admin).to be_falsey
    end

    it "can be set to true" do
      user = User.create!(
        email: "admin@example.com",
        password: "password123",
        admin: true
      )
      expect(user.admin).to be_truthy
    end
  end
end
