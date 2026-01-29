# frozen_string_literal: true

require "rails_helper"

RSpec.describe User::Recoverable, type: :model do
  let(:user) do
    User.create!(
      email: "recoverable@example.com",
      password: "password123"
    )
  end

  describe "#send_reset_password_instructions" do
    it "generates reset token and sends email" do
      expect do
        user.send_reset_password_instructions
      end.to have_enqueued_job(ActionMailer::MailDeliveryJob)

      expect(user.reset_password_token).to be_present
      expect(user.reset_password_sent_at).to be_within(1.second).of(Time.current)
    end

    it "generates unique token even if collision occurs" do
      existing_user = User.create!(
        email: "existing@example.com",
        password: "password123",
        reset_password_token: "collision-token"
      )

      allow(SecureRandom).to receive(:urlsafe_base64).and_return("collision-token", "unique-token")
      user.send_reset_password_instructions
      expect(user.reset_password_token).to eq("unique-token")
    end
  end

  describe "#reset_password" do
    before do
      user.send_reset_password_instructions
    end

    it "resets password with valid token" do
      result = user.reset_password(
        password: "new_password_123",
        password_confirmation: "new_password_123"
      )

      expect(result).to be true
      expect(user.reset_password_token).to be_nil
      expect(user.authenticate("new_password_123")).to eq(user)
    end

    it "returns false with invalid password confirmation" do
      result = user.reset_password(
        password: "new_password_123",
        password_confirmation: "wrong"
      )

      expect(result).to be false
      expect(user.reset_password_token).to be_present
    end

    it "returns false when token is expired" do
      user.update_column(:reset_password_sent_at, 7.hours.ago)

      result = user.reset_password(
        password: "new_password_123",
        password_confirmation: "new_password_123"
      )

      expect(result).to be false
    end

    it "returns false when token is missing" do
      user.update_column(:reset_password_token, nil)

      result = user.reset_password(
        password: "new_password_123",
        password_confirmation: "new_password_123"
      )

      expect(result).to be false
    end
  end

  describe "#reset_password_period_valid?" do
    it "returns true when token is valid and not expired" do
      user.send_reset_password_instructions
      expect(user.reset_password_period_valid?).to be true
    end

    it "returns false when token is missing" do
      expect(user.reset_password_period_valid?).to be false
    end

    it "returns false when sent_at is missing" do
      user.update_column(:reset_password_token, SecureRandom.urlsafe_base64(32))
      user.update_column(:reset_password_sent_at, nil)
      expect(user.reset_password_period_valid?).to be false
    end

    it "returns false when token is expired (>6 hours)" do
      user.update_column(:reset_password_token, SecureRandom.urlsafe_base64(32))
      user.update_column(:reset_password_sent_at, 7.hours.ago)
      expect(user.reset_password_period_valid?).to be false
    end

    it "returns true when token is within 6 hours" do
      user.update_column(:reset_password_token, SecureRandom.urlsafe_base64(32))
      user.update_column(:reset_password_sent_at, 5.hours.ago)
      expect(user.reset_password_period_valid?).to be true
    end
  end
end
