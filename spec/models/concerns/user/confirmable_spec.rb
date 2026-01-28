require "rails_helper"

RSpec.describe User::Confirmable, type: :model do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123"
    )
  end

  describe "#confirmed?" do
    it "returns false when not confirmed" do
      expect(user.confirmed?).to be_falsey
    end

    it "returns true when confirmed_at is present" do
      user.update_column(:confirmed_at, Time.current)
      expect(user.confirmed?).to be_truthy
    end
  end

  describe "#confirm!" do
    it "marks user as confirmed" do
      expect(user.confirmed?).to be_falsey
      user.confirm!
      expect(user.confirmed?).to be_truthy
    end

    it "clears confirmation_token" do
      user.update_column(:confirmation_token, "some-token")
      user.confirm!
      expect(user.confirmation_token).to be_nil
    end

    it "is idempotent" do
      user.confirm!
      expect { user.confirm! }.not_to change { user.confirmed_at }
    end
  end

  describe "#send_confirmation_instructions" do
    it "generates token and sends email" do
      expect do
        user.send_confirmation_instructions
      end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      expect(user.confirmation_token).to be_present
    end

    it "updates confirmation_sent_at" do
      user.send_confirmation_instructions
      expect(user.confirmation_sent_at).to be_within(1.second).of(Time.current)
    end
  end

  describe "#confirmation_period_valid?" do
    it "returns false when confirmation_sent_at is nil" do
      expect(user.confirmation_period_valid?).to be_falsey
    end

    it "returns true when sent within 24 hours" do
      user.update_column(:confirmation_sent_at, 1.hour.ago)
      expect(user.confirmation_period_valid?).to be_truthy
    end

    it "returns false when sent more than 24 hours ago" do
      user.update_column(:confirmation_sent_at, 25.hours.ago)
      expect(user.confirmation_period_valid?).to be_falsey
    end
  end

  describe "#generate_confirmation_token!" do
    it "generates a unique token even if collision occurs" do
      existing_user = User.create!(
        email: "existing@example.com",
        password: "password123",
        confirmation_token: "collision-token"
      )

      allow(SecureRandom).to receive(:urlsafe_base64).and_return("collision-token", "unique-token")
      user.send(:generate_confirmation_token!)
      expect(user.confirmation_token).to eq("unique-token")
    end
  end
end
