##
# Base channel class for Action Cable.
#
# All channel classes should inherit from this class.
# Provides shared logic and behavior for all channels.
#
# @example Create a custom channel
#   class ChatChannel < ApplicationCable::Channel
#     def subscribed
#       stream_from "chat_#{params[:room]}"
#     end
#   end
#
# @see https://guides.rubyonrails.org/action_cable_overview.html
module ApplicationCable
  class Channel < ActionCable::Channel::Base
  end
end
