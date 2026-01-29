##
# Base mailer for all application emails.
#
# Provides default configuration for all mailers, including:
# - Default sender address
# - Mailer layout template
#
# @example Creating a new mailer
#   class UserMailer < ApplicationMailer
#     def welcome(user)
#       @user = user
#       mail(to: user.email, subject: "Welcome!")
#     end
#   end
#
# @see https://guides.rubyonrails.org/action_mailer_basics.html
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  layout "mailer"
end
