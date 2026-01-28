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

  describe "#admin?" do
    it "returns true when admin flag is true" do
      user = User.create!(email: "admin_flag@example.com", password: "password123", admin: true)
      expect(user.admin?).to be true
    end

    it "returns true when user has admin role but flag is false" do
      user = User.create!(email: "admin_role@example.com", password: "password123", admin: false)
      user.add_role(:admin)
      expect(user.admin?).to be true
    end
  end

  describe "#make_admin! and #remove_admin!" do
    it "adds admin role and sets admin flag" do
      user = User.create!(email: "make_admin@example.com", password: "password123", admin: false)

      user.make_admin!
      user.reload

      expect(user.admin).to be true
      expect(user.has_role?(:admin)).to be true
    end

    it "removes admin role and clears admin flag" do
      user = User.create!(email: "remove_admin@example.com", password: "password123", admin: true)
      user.add_role(:admin)

      user.remove_admin!
      user.reload

      expect(user.admin).to be false
      expect(user.has_role?(:admin)).to be false
    end
  end

  describe ".find_by_remember_token" do
    it "returns nil when token is blank" do
      expect(User.find_by_remember_token(nil)).to be_nil
      expect(User.find_by_remember_token("")).to be_nil
    end

    it "finds user by remember token when token is present" do
      user = User.create!(email: "remember@example.com", password: "password123")
      user.remember_me!
      token = user.remember_token

      found = User.find_by_remember_token(token)
      expect(found).to eq(user)
    end
  end
end
