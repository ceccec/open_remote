require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "confirmation_instructions" do
    mail = UserMailer.confirmation_instructions
    assert_equal "Confirmation instructions", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "reset_password_instructions" do
    mail = UserMailer.reset_password_instructions
    assert_equal "Reset password instructions", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "unlock_instructions" do
    mail = UserMailer.unlock_instructions
    assert_equal "Unlock instructions", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
