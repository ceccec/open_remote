---
title: Action Cable Overview Review
lastUpdated: 2026-01-28
---

# Action Cable Overview Review

**Date:** January 28, 2026  
**Guide:** [Action Cable Overview](https://guides.rubyonrails.org/action_cable_overview.html)

## Executive Summary

The application demonstrates **excellent** Action Cable setup with proper connection authentication, Solid Cable adapter configuration, and well-structured base classes. The implementation aligns well with Rails best practices.

**Overall Assessment:** ✅ **Excellent** - Action Cable is properly configured and ready for use.

---

## Current Action Cable Implementation

### 1. Connection Setup

#### ApplicationCable::Connection (`app/channels/application_cable/connection.rb`)

```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      session_data = cookies.encrypted["_session"] || cookies.encrypted[:_session] || {}
      user_id = session_data["user_id"] || session_data[:user_id]

      if user_id && (verified_user = User.find_by(id: user_id))
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
```

✅ **Strengths:**
- Properly inherits from `ActionCable::Connection::Base`
- Uses `identified_by :current_user` for connection identification
- Verifies user from encrypted session cookie
- Rejects unauthorized connections
- Well-documented with examples
- Handles both string and symbol keys for session data

**Connection Authentication:**
- ✅ Uses encrypted cookies for session access
- ✅ Verifies user exists before allowing connection
- ✅ Properly rejects unauthorized connections
- ✅ Follows Rails best practices

### 2. Channel Setup

#### ApplicationCable::Channel (`app/channels/application_cable/channel.rb`)

```ruby
module ApplicationCable
  class Channel < ActionCable::Channel::Base
  end
end
```

✅ **Strengths:**
- Properly inherits from `ActionCable::Channel::Base`
- Ready for custom channel implementations
- Well-documented with examples

**Status:** ✅ **No Issues** - Base channel class is properly set up.

### 3. Configuration

#### Cable Configuration (`config/cable.yml`)

```yaml
development:
  adapter: async

test:
  adapter: test

production:
  adapter: solid_cable
  connects_to:
    database:
      writing: cable
  polling_interval: 0.1.seconds
  message_retention: 1.day
```ruby

✅ **Strengths:**
- Uses `async` adapter for development (appropriate)
- Uses `test` adapter for testing (appropriate)
- Uses `solid_cable` adapter for production (database-backed)
- Configures separate database for cable
- Sets appropriate polling interval
- Configures message retention

#### Database Configuration
```yaml
production:
  cable:
    <<: *primary_production
    database: open_remote_production_cable
    migrations_paths: db/cable_migrate
```ruby

✅ **Strengths:**
- Separate database for cable (production)
- Proper migrations path configuration
- Follows Rails 8 conventions

#### Environment Configuration
```
# config/environments/development.rb
# Action Cable configuration
# Allow requests from localhost:3000 by default in development
# config.action_cable.allowed_request_origins = ["http://localhost:3000"]
```ruby

✅ **Strengths:**
- Comments explain default behavior
- Ready for configuration if needed

### 4. Layout Integration

**Application Layout:**
```erb
<%= action_cable_meta_tag %>
```ruby

✅ **Strengths:**
- Includes Action Cable meta tag in layout
- Enables automatic consumer connection
- Follows Rails conventions

---

## Areas for Enhancement

### 1. Custom Channels

**Current Status:** No custom channels are implemented.

**Recommendation:**
If you need real-time features, create custom channels:

```
# app/channels/notifications_channel.rb
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end
end
```ruby

**Status:** ✅ **No Issues** - Channels not needed currently, but infrastructure is ready.

### 2. Allowed Request Origins

**Current Status:** Uses default development behavior (localhost:3000).

**Recommendation:**
Configure allowed origins for production:

```
# config/environments/production.rb
config.action_cable.allowed_request_origins = [
  "https://example.com",
  %r{https://.*\.example\.com}
]
```ruby

**Status:** ⚠️ **Enhancement Needed** - Should be configured for production.

### 3. Worker Pool Configuration

**Current Status:** Uses default worker pool size (4).

**Recommendation:**
Configure worker pool size if needed:

```
# config/environments/production.rb
config.action_cable.worker_pool_size = 4
```ruby

**Status:** ✅ **No Issues** - Default is appropriate for most applications.

### 4. Client-Side Consumer

**Current Status:** No client-side channels found.

**Recommendation:**
If you add channels, create client-side subscriptions:

```javascript
// app/javascript/channels/notifications_channel.js
import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  received(data) {
    // Handle notification
  }
})
```ruby

**Status:** ✅ **No Issues** - Not needed until channels are implemented.

---

## Best Practices Compliance

### ✅ Connection Setup
- Proper authentication from session
- Uses `identified_by` for connection identification
- Rejects unauthorized connections
- Well-documented

### ✅ Channel Setup
- Proper base channel class
- Ready for custom implementations

### ✅ Configuration
- Appropriate adapters for each environment
- Separate database for production
- Proper polling and retention settings

### ✅ Layout Integration
- Includes Action Cable meta tag
- Enables automatic consumer connection

---

## Recommendations

### High Priority
1. **Configure allowed request origins for production:**
   - Set `config.action_cable.allowed_request_origins` in production
   - Prevent unauthorized WebSocket connections

### Medium Priority
2. **Add custom channels when needed:**
   - Create channels for real-time features
   - Implement client-side subscriptions

### Low Priority
3. **Configure worker pool size if needed:**
   - Adjust based on application load
   - Ensure database pool matches worker pool

---

## Conclusion

The application demonstrates **excellent** Action Cable setup:

✅ **Strengths:**
- Proper connection authentication
- Solid Cable adapter configuration
- Separate database for production
- Well-structured base classes
- Ready for custom channel implementation

⚠️ **Enhancement Needed:**
- Configure allowed request origins for production

**Overall:** The Action Cable implementation aligns well with Rails best practices. The infrastructure is properly set up and ready for real-time features when needed.
