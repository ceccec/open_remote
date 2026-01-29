require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "confirmation_instructions" do
    @user.update_column(:confirmation_token, "test_confirmation_token")
    mail = UserMailer.with(user: @user).confirmation_instructions
    assert_equal "Confirm your account", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_equal [ "noreply@example.com" ], mail.from
    assert_match "test_confirmation_token", mail.body.encoded
  end

  test "reset_password_instructions" do
    @user.update_column(:reset_password_token, "test_reset_token")
    mail = UserMailer.with(user: @user).reset_password_instructions
    assert_equal "Reset your password", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_equal [ "noreply@example.com" ], mail.from
    assert_match "test_reset_token", mail.body.encoded
  end

  test "unlock_instructions" do
    @user.update_column(:unlock_token, "test_unlock_token")
    mail = UserMailer.with(user: @user).unlock_instructions
    assert_equal "Unlock your account", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_equal [ "noreply@example.com" ], mail.from
    assert_match "test_unlock_token", mail.body.encoded
  end
end
