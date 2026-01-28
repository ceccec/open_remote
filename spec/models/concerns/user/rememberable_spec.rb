require "rails_helper"

RSpec.describe User::Rememberable, type: :model do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123"
    )
  end

  describe "#remember_me!" do
    it "generates a remember token" do
      expect(user.remember_token).to be_nil
      user.remember_me!
      expect(user.remember_token).to be_present
    end

    it "sets remember_created_at" do
      expect(user.remember_created_at).to be_nil
      user.remember_me!
      expect(user.remember_created_at).to be_within(1.second).of(Time.current)
    end

    it "returns the remember token" do
      token = user.remember_me!
      expect(token).to eq(user.remember_token)
    end

    it "generates a unique token" do
      user1 = User.create!(email: "user1@example.com", password: "password123")
      user2 = User.create!(email: "user2@example.com", password: "password123")
      user1.remember_me!
      user2.remember_me!
      expect(user1.remember_token).not_to eq(user2.remember_token)
    end
  end

  describe "#forget_me!" do
    before do
      user.remember_me!
    end

    it "clears the remember token" do
      expect(user.remember_token).to be_present
      user.forget_me!
      user.reload
      expect(user.remember_token).to be_nil
    end

    it "clears remember_created_at" do
      expect(user.remember_created_at).to be_present
      user.forget_me!
      user.reload
      expect(user.remember_created_at).to be_nil
    end
  end

  describe "#remember_token_valid?" do
    context "when token is present and not expired" do
      before do
        user.remember_me!
      end

      it "returns true" do
        expect(user.remember_token_valid?).to be_truthy
      end
    end

    context "when token is nil" do
      it "returns false" do
        expect(user.remember_token_valid?).to be_falsey
      end
    end

    context "when remember_created_at is nil" do
      before do
        user.update_column(:remember_token, SecureRandom.urlsafe_base64(32))
        user.update_column(:remember_created_at, nil)
      end

      it "returns false" do
        expect(user.remember_token_valid?).to be_falsey
      end
    end

    context "when token is expired (older than 2 weeks)" do
      before do
        user.update_column(:remember_token, SecureRandom.urlsafe_base64(32))
        user.update_column(:remember_created_at, 3.weeks.ago)
      end

      it "returns false" do
        expect(user.remember_token_valid?).to be_falsey
      end
    end
  end
end
