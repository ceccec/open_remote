---
title: Action Mailer Basics Review
lastUpdated: 2026-01-28
---

# Action Mailer Basics Review

**Date:** January 28, 2026  
**Guide:** [Action Mailer Basics](https://guides.rubyonrails.org/action_mailer_basics.html)

## Executive Summary

The application demonstrates **excellent** use of Action Mailer with proper mailer structure, multipart emails (HTML and text), appropriate use of layouts, and good URL generation. The implementation aligns well with Rails best practices.

**Overall Assessment:** ✅ **Excellent** - Action Mailer implementation follows Rails conventions.

---

## Current Mailer Implementation

### 1. Mailer Structure

#### ApplicationMailer (`app/mailers/application_mailer.rb`)

```ruby
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  layout "mailer"
end
```

✅ **Strengths:**
- Properly inherits from `ActionMailer::Base`
- Sets default `from` address
- Configures mailer layout
- Follows Rails conventions

#### UserMailer (`app/mailers/user_mailer.rb`)

```ruby
class UserMailer < ApplicationMailer
  def confirmation_instructions
    @user = params[:user]
    @confirmation_url = confirmation_url(@user.confirmation_token)
    mail(to: @user.email, subject: "Confirm your account")
  end

  def reset_password_instructions
    @user = params[:user]
    @reset_password_url = edit_password_url(@user.reset_password_token)
    mail(to: @user.email, subject: "Reset your password")
  end

  def unlock_instructions
    @user = params[:user]
    @unlock_url = unlock_url(@user.unlock_token)
    mail(to: @user.email, subject: "Unlock your account")
  end
end
```

✅ **Strengths:**
- Well-organized mailer actions
- Uses `params[:user]` pattern (parameterized mailers)
- Generates URLs using `*_url` helpers (not `*_path`)
- Clear, descriptive method names
- Proper instance variable assignment for views

### 2. Mailer Views

#### HTML Views

**Example:** `app/views/user_mailer/confirmation_instructions.html.erb`
```erb
<h1>Confirm your account</h1>
<p>Hello <%= @user.email %>,</p>
<p>Please confirm your account by clicking the link below:</p>
<p><%= link_to "Confirm my account", @confirmation_url %></p>
<p>If you didn't create an account, please ignore this email.</p>
<p>This link will expire in 24 hours.</p>
```ruby

✅ **Strengths:**
- Clean, readable HTML structure
- Uses instance variables from mailer
- Uses `link_to` helper with full URL
- User-friendly messaging

#### Text Views

**Example:** `app/views/user_mailer/confirmation_instructions.text.erb`
```erb
Confirm your account

Hello <%= @user.email %>,

Please confirm your account by visiting the following URL:

<%= @confirmation_url %>

If you didn't create an account, please ignore this email.

This link will expire in 24 hours.
```ruby

✅ **Strengths:**
- Provides text version for all emails
- Same content as HTML version
- Plain text formatting
- Includes all necessary information

**Multipart Emails:**
- ✅ All mailer actions have both HTML and text templates
- ✅ Action Mailer automatically creates `multipart/alternative` emails
- ✅ Follows email best practices

### 3. Mailer Layouts

**Mailer Layout:** `app/views/layouts/mailer.html.erb`
```erb
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style>
      /* Email styles need to be inline */
    </style>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```ruby

✅ **Strengths:**
- Proper email HTML structure
- Includes charset meta tag
- Comment about inline styles (email best practice)
- Simple `yield` for email content

**Text Layout:** `app/views/layouts/mailer.text.erb`
- ✅ Exists for text email formatting

### 4. URL Generation

**Current Implementation:**
```ruby
def confirmation_url(token)
  main_app.confirmation_url(token)
end

def edit_password_url(token)
  main_app.edit_password_url(token)
end

def unlock_url(token)
  main_app.unlock_url(token)
end
```

✅ **Strengths:**
- Uses `*_url` helpers (full URLs, not paths)
- Uses `main_app` prefix for engine routes
- Extracted to private methods for reusability
- Follows Rails best practices for email URLs

**Configuration:**
```ruby
# config/environments/production.rb
config.action_mailer.default_url_options = { host: "example.com" }
```

✅ **Strengths:**
- Configures default host for URL generation
- Environment-specific configuration

### 5. Email Delivery

**Current Usage:**
```ruby
UserMailer.with(user: self).confirmation_instructions.deliver_later
UserMailer.with(user: self).reset_password_instructions.deliver_later
UserMailer.with(user: self).unlock_instructions.deliver_later
```

✅ **Strengths:**
- Uses `deliver_later` for asynchronous delivery
- Uses parameterized mailers (`with(user: self)`)
- Follows Rails best practices
- Non-blocking email delivery

### 6. Email Actions

**Current Mailer Actions:**
1. `confirmation_instructions` - Email confirmation
2. `reset_password_instructions` - Password reset
3. `unlock_instructions` - Account unlock

✅ **Strengths:**
- Clear, descriptive action names
- Consistent structure across all actions
- Proper use of instance variables
- Good separation of concerns

---

## Areas for Enhancement

### 1. Email Styling

**Current Status:** Mailer layout has empty `<style>` block.

**Recommendation:**
Add inline CSS styles for better email client compatibility:

```erb
<style>
  body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
  .container { max-width: 600px; margin: 0 auto; padding: 20px; }
  .button { display: inline-block; padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; }
</style>
```ruby

**Status:** ⚠️ **Optional Enhancement** - Current emails work but could be more visually appealing.

### 2. Email Configuration

**Current Status:**
```
config.action_mailer.default_url_options = { host: "example.com" }
```ruby

**Recommendation:**
- Update `host` to actual production domain
- Configure SMTP settings for production
- Consider using environment variables

**Status:** ⚠️ **Enhancement Needed** - `example.com` should be replaced with actual domain.

### 3. Email Preview Classes

**Current Status:** No email preview classes found.

**Recommendation:**
Create preview classes for testing emails:

```ruby
# test/mailers/previews/user_mailer_preview.rb
class UserMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    UserMailer.with(user: User.first).confirmation_instructions
  end
end
```

**Status:** ⚠️ **Optional Enhancement** - Previews are helpful for development but not required.

### 4. Error Handling

**Current Status:** No error handling for email delivery failures.

**Recommendation:**
Consider adding error handling:

```ruby
rescue_from Net::SMTPError do |exception|
  Rails.logger.error "Email delivery failed: #{exception.message}"
  # Handle error appropriately
end
```

**Status:** ⚠️ **Optional Enhancement** - Current approach relies on Active Job error handling.

### 5. Email Subject Translation

**Current Status:** Hard-coded English subjects.

**Recommendation:**
Consider using I18n for email subjects:

```ruby
mail(to: @user.email, subject: t('.subject'))
```

**Status:** ⚠️ **Optional Enhancement** - Current approach works but I18n would improve internationalization.

---

## Best Practices Compliance

### ✅ Mailer Structure
- Properly inherits from `ApplicationMailer`
- Well-organized actions
- Uses parameterized mailers

### ✅ Views
- Both HTML and text templates for all emails
- Proper use of instance variables
- Clean, readable templates

### ✅ Layouts
- Separate mailer layout
- Proper HTML structure
- Email-friendly formatting

### ✅ URL Generation
- Uses `*_url` helpers (full URLs)
- Configures default host
- Proper route helpers

### ✅ Delivery
- Uses `deliver_later` for asynchronous delivery
- Non-blocking email sending
- Proper Active Job integration

---

## Recommendations

### High Priority
1. **Update email configuration:**
   - Replace `example.com` with actual production domain
   - Configure SMTP settings for production

### Medium Priority
2. **Add email styling:**
   - Add inline CSS to mailer layout
   - Improve visual appearance of emails

3. **Create email preview classes:**
   - Add preview classes for development testing
   - Improve developer experience

### Low Priority
4. **Add error handling:**
   - Handle email delivery failures
   - Log errors appropriately

5. **Consider I18n for email subjects:**
   - Use translations for email subjects
   - Improve internationalization support

---

## Conclusion

The application demonstrates **excellent** Action Mailer practices:

✅ **Strengths:**
- Proper mailer structure and inheritance
- Multipart emails (HTML and text)
- Appropriate use of layouts
- Good URL generation (`*_url` helpers)
- Asynchronous email delivery (`deliver_later`)
- Clean, readable email templates

⚠️ **Enhancements Needed:**
- Update `default_url_options` host from `example.com`
- Consider adding email styling
- Consider creating email preview classes

**Overall:** The Action Mailer implementation aligns well with Rails best practices. The main enhancement needed is updating the email configuration for production use.
