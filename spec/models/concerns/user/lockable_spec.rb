require "rails_helper"

RSpec.describe User::Lockable, type: :model do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123"
    )
  end

  describe "#access_locked?" do
    it "returns false when not locked" do
      expect(user.access_locked?).to be_falsey
    end

    it "returns true when locked and lock not expired" do
      user.update_columns(locked_at: 1.hour.ago, failed_attempts: 5)
      expect(user.access_locked?).to be_truthy
    end

    it "returns false when lock has expired" do
      user.update_columns(locked_at: 3.hours.ago, failed_attempts: 5)
      expect(user.access_locked?).to be_falsey
    end
  end

  describe "#increment_failed_attempts!" do
    it "increments failed attempts" do
      expect(user.failed_attempts).to eq(0)
      user.increment_failed_attempts!
      expect(user.failed_attempts).to eq(1)
    end

    it "does not increment if already locked" do
      user.update_columns(locked_at: 1.hour.ago, failed_attempts: 5)
      initial_attempts = user.failed_attempts
      user.increment_failed_attempts!
      expect(user.failed_attempts).to eq(initial_attempts)
    end

    it "locks account after maximum failed attempts" do
      user.update_column(:failed_attempts, 4)
      user.increment_failed_attempts!
      expect(user.access_locked?).to be_truthy
      expect(user.failed_attempts).to eq(5)
    end
  end

  describe "#lock_access!" do
    it "locks the account" do
      user.lock_access!
      expect(user.access_locked?).to be_truthy
      expect(user.failed_attempts).to eq(5)
    end
  end

  describe "#unlock_access!" do
    before do
      user.update_columns(locked_at: Time.current, failed_attempts: 5, unlock_token: "token")
    end

    it "unlocks the account" do
      user.unlock_access!
      expect(user.access_locked?).to be_falsey
      expect(user.failed_attempts).to eq(0)
      expect(user.unlock_token).to be_nil
    end
  end

  describe "#send_unlock_instructions" do
    before do
      user.update_columns(locked_at: Time.current, failed_attempts: 5)
    end

    it "generates unlock token and sends email" do
      expect do
        token = user.send_unlock_instructions
        expect(token).to be_present
      end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end
  end

  describe "#reset_failed_attempts!" do
    it "resets attempts when account is locked" do
      user.update_columns(locked_at: Time.current, failed_attempts: 5)
      user.send(:reset_failed_attempts!)
      expect(user.failed_attempts).to eq(0)
    end
  end

  describe "#generate_unlock_token!" do
    it "generates a unique token even if collision occurs" do
      existing_user = User.create!(
        email: "existing@example.com",
        password: "password123",
        unlock_token: "collision-token"
      )

      allow(SecureRandom).to receive(:urlsafe_base64).and_return("collision-token", "unique-token")
      user.send(:generate_unlock_token!)
      expect(user.unlock_token).to eq("unique-token")
    end
  end
end
