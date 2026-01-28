require "rails_helper"

RSpec.describe User::Seedable, type: :model do
  describe ".ensure_default_roles!" do
    it "ensures default roles exist" do
      User.ensure_default_roles!
      names = Role.where(name: described_class::DEFAULT_ROLES).pluck(:name)
      expect(names).to contain_exactly("admin", "manager", "viewer")
    end

    it "does not create duplicate roles when called multiple times" do
      User.ensure_default_roles!
      counts_before = Role.where(name: described_class::DEFAULT_ROLES).group(:name).count
      User.ensure_default_roles!
      counts_after = Role.where(name: described_class::DEFAULT_ROLES).group(:name).count
      expect(counts_after).to eq(counts_before)
    end
  end

  describe ".generate_secure_password" do
    it "generates a password of default length (16)" do
      password = User.generate_secure_password
      expect(password.length).to eq(16)
    end

    it "generates a password of specified length" do
      password = User.generate_secure_password(length: 20)
      expect(password.length).to eq(20)
    end

    it "enforces minimum length of 12" do
      password = User.generate_secure_password(length: 5)
      expect(password.length).to eq(12)
    end

    it "includes at least one lowercase letter" do
      password = User.generate_secure_password
      expect(password).to match(/[a-z]/)
    end

    it "includes at least one uppercase letter" do
      password = User.generate_secure_password
      expect(password).to match(/[A-Z]/)
    end

    it "includes at least one number" do
      password = User.generate_secure_password
      expect(password).to match(/[0-9]/)
    end

    it "includes at least one special character" do
      password = User.generate_secure_password
      expect(password).to match(/[!@#\$%^&*\-_+=]/)
    end

    it "generates different passwords each time" do
      passwords = 10.times.map { User.generate_secure_password }
      expect(passwords.uniq.length).to eq(10)
    end
  end

  describe ".ensure_super_admin!" do
    before do
      User.ensure_default_roles!
    end

    context "when user does not exist" do
      let(:email) { "new_admin@example.com" }

      it "creates a new super admin user" do
        expect do
          @user = User.ensure_super_admin!(email: email)
        end.to change { User.where(email: email).count }.from(0).to(1)
        expect(@user.email).to eq(email)
      end

      it "sets admin flag to true" do
        user = User.ensure_super_admin!(email: email)
        expect(user.admin).to be_truthy
      end

      it "assigns admin role" do
        user = User.ensure_super_admin!(email: email)
        expect(user.has_role?(:admin)).to be_truthy
      end

      it "confirms the user" do
        user = User.ensure_super_admin!(email: email)
        expect(user.confirmed?).to be_truthy
        expect(user.confirmed_at).to be_present
      end

      it "unlocks the account" do
        user = User.ensure_super_admin!(email: email)
        expect(user.locked_at).to be_nil
        expect(user.failed_attempts).to eq(0)
      end

      it "generates a password if none provided" do
        user = User.ensure_super_admin!(email: email)
        expect(user.password_digest).to be_present
        expect(user.seed_password_to_set).to be_present
      end

      it "uses provided password if given" do
        user = User.ensure_super_admin!(email: email, password: "custom123")
        expect(user.authenticate("custom123")).to eq(user)
        expect(user.seed_password_to_set).to eq("custom123")
      end
    end

    context "when user already exists" do
      let!(:existing_user) do
        User.create!(
          email: "admin@example.com",
          password: "oldpassword",
          admin: false,
          confirmed_at: nil
        )
      end

      it "does not change password unless explicitly provided" do
        old_digest = existing_user.password_digest
        user = User.ensure_super_admin!(email: "admin@example.com")
        expect(user.password_digest).to eq(old_digest)
        expect(user.seed_password_to_set).to be_nil
      end

      it "updates password if explicitly provided" do
        user = User.ensure_super_admin!(email: "admin@example.com", password: "newpassword")
        expect(user.authenticate("newpassword")).to eq(user)
        expect(user.seed_password_to_set).to eq("newpassword")
      end

      it "sets admin flag to true" do
        user = User.ensure_super_admin!(email: "admin@example.com")
        expect(user.admin).to be_truthy
      end

      it "assigns admin role if missing" do
        user = User.ensure_super_admin!(email: "admin@example.com")
        expect(user.has_role?(:admin)).to be_truthy
      end

      it "confirms the user if not confirmed" do
        user = User.ensure_super_admin!(email: "admin@example.com")
        expect(user.confirmed?).to be_truthy
      end

      it "unlocks the account" do
        existing_user.update_columns(locked_at: Time.current, failed_attempts: 5)
        user = User.ensure_super_admin!(email: "admin@example.com")
        expect(user.locked_at).to be_nil
        expect(user.failed_attempts).to eq(0)
      end
    end
  end
end
