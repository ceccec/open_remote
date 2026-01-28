# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/confirmation_instructions
  def confirmation_instructions
    UserMailer.confirmation_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/reset_password_instructions
  def reset_password_instructions
    UserMailer.reset_password_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/unlock_instructions
  def unlock_instructions
    UserMailer.unlock_instructions
  end
end
