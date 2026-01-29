##
# Base mailbox class for routing incoming emails.
#
# Action Mailbox routes incoming emails to controller-like mailboxes for processing.
# Configure routing using regular expressions that match email addresses.
#
# @example Route emails to a forwards mailbox
#   routing(/^save@/i => :forwards)
#   routing(/@replies\./i => :replies)
#
# @see https://guides.rubyonrails.org/action_mailbox_basics.html
class ApplicationMailbox < ActionMailbox::Base
  # Add routing rules here as mailboxes are created
  # Example:
  # routing(/^save@/i => :forwards)
  # routing(/@replies\./i => :replies)
end
