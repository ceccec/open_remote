require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  describe "#confirmation_instructions" do
    let(:mail) { UserMailer.confirmation_instructions(user) }

    before do
      user.update_column(:confirmation_token, "test_token")
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm your account")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "assigns confirmation_url" do
      expect(mail.body.encoded).to include("test_token")
    end
  end

  describe "#reset_password_instructions" do
    let(:mail) { UserMailer.reset_password_instructions(user) }

    before do
      user.update_column(:reset_password_token, "reset_token")
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "assigns reset_password_url" do
      expect(mail.body.encoded).to include("reset_token")
    end
  end

  describe "#unlock_instructions" do
    let(:mail) { UserMailer.unlock_instructions(user) }

    before do
      user.update_column(:unlock_token, "unlock_token")
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Unlock your account")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "assigns unlock_url" do
      expect(mail.body.encoded).to include("unlock_token")
    end
  end
end
