// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.
//
// @example Create a subscription
//   import consumer from "./consumer"
//   consumer.subscriptions.create({ channel: "ChatChannel", room: "Best Room" })
//
// @see https://guides.rubyonrails.org/action_cable_overview.html

import { createConsumer } from "@rails/actioncable"

export default createConsumer()
