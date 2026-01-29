---
title: Action Controller Overview Review
lastUpdated: 2026-01-28
---

# Action Controller Overview Review

**Date:** January 28, 2026  
**Guide:** [Action Controller Overview](https://guides.rubyonrails.org/action_controller_overview.html)

## Executive Summary

The application demonstrates **excellent** use of Action Controller with proper strong parameters, secure session management, appropriate use of controller callbacks, and good flash message handling. The implementation aligns well with Rails best practices.

**Overall Assessment:** ✅ **Excellent** - Controllers are well-structured and follow Rails conventions.

---

## Current Controller Implementation

### 1. Controller Structure and Inheritance

**ApplicationController:**
```ruby
class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes
  helper_method :current_user, :logged_in?
  before_action :authenticate_user!
end
```

✅ **Strengths:**
- Properly inherits from `ActionController::Base`
- Uses `helper_method` to expose controller methods to views
- Sets up authentication as a `before_action` callback
- Uses modern Rails features (`allow_browser`, `stale_when_importmap_changes`)

**Controller Naming:**
- ✅ Controllers follow Rails conventions (plural names: `SessionsController`, `RegistrationsController`)
- ✅ Actions are public methods
- ✅ Helper methods are private/protected

### 2. Strong Parameters

**Current Usage:**
```ruby
# RegistrationsController
def user_params
  params.require(:user).permit(:email, :password, :password_confirmation)
end

def user_update_params
  params.require(:user).permit(:email, :password, :password_confirmation)
end
```

✅ **Strengths:**
- Uses `params.require()` to ensure required parameters
- Uses `permit()` to whitelist allowed attributes
- Encapsulates parameter handling in private methods
- Separate methods for create vs update (good practice)

⚠️ **Areas for Enhancement:**
- Some controllers access `params[:email]` and `params[:user][:email]` directly without strong parameters
- Consider using `params.expect()` for better error handling (Rails 8.1+)

**Examples of Direct Parameter Access:**
```ruby
# SessionsController
user = User.find_by(email: params[:email])

# PasswordsController, ConfirmationsController, UnlocksController
@user = User.find_by(email: params[:user][:email])
```

**Recommendation:** While direct access is acceptable for simple lookups, consider extracting to parameter methods for consistency:
```ruby
# SessionsController
private

def session_params
  params.permit(:email, :password)
end
```

### 3. Session Management

**Current Implementation:**
```ruby
# ApplicationController
def current_user
  @current_user ||= User.find_by(id: session[:user_id])
end

# SessionsController
def create
  reset_session  # Prevents session fixation
  session[:user_id] = user.id
end

def destroy
  session[:user_id] = nil
end
```

✅ **Strengths:**
- Uses `reset_session` before setting new session (prevents session fixation)
- Properly clears session on logout
- Uses memoization (`@current_user ||=`) for performance
- Session key is simple and clear (`:user_id`)

**Session Security:**
- ✅ `reset_session` is called before login (prevents session fixation attacks)
- ✅ Session is cleared on logout
- ✅ Uses secure session storage (CookieStore by default in Rails)

### 4. Flash Messages

**Current Usage:**
```ruby
# Success messages
redirect_to main_app.login_path, notice: "Logged in successfully"
redirect_to main_app.root_path, notice: "Account updated successfully."

# Error messages
flash.now[:alert] = "Invalid email or password"
render :new, status: :unprocessable_content
```

✅ **Strengths:**
- Uses `notice` and `alert` flash types appropriately
- Uses `flash.now` when rendering (not redirecting)
- Flash messages are passed via `redirect_to` parameters
- Consistent message formatting

**Flash Message Patterns:**
- ✅ Success: `redirect_to ..., notice: "..."`
- ✅ Error: `flash.now[:alert] = "..."` with `render`
- ✅ Security: Generic messages don't reveal sensitive information

### 5. Controller Callbacks

**ApplicationController:**
```ruby
before_action :authenticate_user!
```

**Child Controllers:**
```ruby
skip_before_action :authenticate_user!, only: [ :new, :create ]
```

✅ **Strengths:**
- Uses `before_action` for authentication
- Properly uses `skip_before_action` with `:only` option
- Callbacks are well-organized and documented
- No callback conflicts or ordering issues

**Rate Limiting:**
```ruby
rate_limit to: 10, within: 3.minutes, only: :create
rate_limit to: 5, within: 15.minutes, only: :create
rate_limit to: 5, within: 1.hour, only: :create
```

✅ **Strengths:**
- Uses Rails 8.1 built-in `rate_limit` feature
- Appropriate limits for different actions
- Applied to authentication and sensitive endpoints

### 6. Request/Response Handling

**Request Object Usage:**
- ✅ Uses `params` hash appropriately
- ✅ Accesses route parameters (`params[:confirmation_token]`, `params[:reset_password_token]`)

**Response Object Usage:**
```ruby
# DocsController
response.headers["Cache-Control"] = "public, max-age=3600" if Rails.env.production?
```

✅ **Strengths:**
- Sets custom response headers when needed
- Uses conditional logic for environment-specific behavior

**Status Codes:**
```ruby
render :new, status: :unprocessable_content
redirect_to "/api", status: :found
```

✅ **Strengths:**
- Uses appropriate HTTP status codes
- `:unprocessable_content` (422) for validation errors
- `:found` (302) for redirects

### 7. Redirects and Renders

**Redirect Patterns:**
```ruby
redirect_to main_app.login_path, notice: "..."
redirect_to main_app.root_path, alert: "..."
redirect_to "/login"
```

✅ **Strengths:**
- Uses named route helpers (`main_app.login_path`)
- Includes flash messages in redirects
- Consistent redirect patterns

**Render Patterns:**
```ruby
render :new, status: :unprocessable_content
render file: index_path, layout: false, content_type: "text/html"
```

✅ **Strengths:**
- Renders appropriate templates
- Sets status codes
- Uses `layout: false` when serving static files

### 8. Security Practices

**Authentication:**
- ✅ `before_action :authenticate_user!` in ApplicationController
- ✅ `skip_before_action` for public actions
- ✅ `reset_session` before login (prevents session fixation)

**Authorization:**
```ruby
rescue_from CanCan::AccessDenied do |exception|
  redirect_to main_app.root_path, alert: exception.message
end
```

✅ **Strengths:**
- Uses CanCanCan for authorization
- Handles authorization errors gracefully

**Information Disclosure:**
- ✅ Generic error messages don't reveal if email exists
- ✅ Security-conscious messaging in password reset, confirmation, unlock flows

**Rate Limiting:**
- ✅ Applied to authentication endpoints
- ✅ Prevents brute-force attacks

---

## Areas for Enhancement

### 1. Strong Parameters Consistency

**Current Issue:**
Some controllers access parameters directly without using strong parameters:
- `SessionsController`: `params[:email]`, `params[:password]`
- `PasswordsController`: `params[:user][:email]`, `params[:user][:password]`
- `ConfirmationsController`: `params[:user][:email]`
- `UnlocksController`: `params[:user][:email]`

**Recommendation:**
Extract parameter handling to private methods for consistency:

```ruby
# SessionsController
private

def session_params
  params.permit(:email, :password)
end

# PasswordsController
private

def password_params
  params.fetch(:user, {}).permit(:email, :password, :password_confirmation)
end
```

**Status:** ⚠️ **Optional Enhancement** - Current approach works but could be more consistent.

### 2. Using `params.expect()` (Rails 8.1+)

**Current Usage:**
```ruby
params.require(:user).permit(:email, :password, :password_confirmation)
```

**Recommendation:**
Consider using `expect()` for better error handling:
```ruby
params.expect(user: [:email, :password, :password_confirmation])
```

**Status:** ⚠️ **Optional Enhancement** - `permit()` works fine, but `expect()` provides better error messages.

### 3. Error Handling

**Current Implementation:**
- Uses `rescue_from` for CanCan authorization errors
- Handles validation errors with `render` and flash messages

**Recommendation:**
Consider adding error handling for other exceptions:
```ruby
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

private

def record_not_found
  redirect_to main_app.root_path, alert: "Record not found"
end
```

**Status:** ⚠️ **Optional Enhancement** - Current error handling is adequate.

### 4. Controller Callbacks Documentation

**Current Status:**
Callbacks are well-documented, but could benefit from more inline comments explaining why certain actions skip authentication.

**Status:** ✅ **No Issues** - Documentation is good.

---

## Controller Best Practices Compliance

### ✅ Controller Structure
- Controllers inherit from `ApplicationController`
- Actions are public methods
- Helper methods are private/protected
- Follows Rails naming conventions

### ✅ Strong Parameters
- Uses `require()` and `permit()` appropriately
- Encapsulates parameter handling in private methods
- Prevents mass assignment vulnerabilities

### ✅ Session Management
- Uses `reset_session` before login (security)
- Properly clears session on logout
- Uses memoization for performance

### ✅ Flash Messages
- Uses `notice` and `alert` appropriately
- Uses `flash.now` when rendering
- Consistent message patterns

### ✅ Controller Callbacks
- Uses `before_action` appropriately
- Uses `skip_before_action` with `:only` option
- Well-organized and documented

### ✅ Security
- Authentication required by default
- Rate limiting on sensitive endpoints
- Generic error messages (no information disclosure)
- Session fixation protection

### ✅ Request/Response
- Appropriate HTTP status codes
- Custom headers when needed
- Proper use of redirects and renders

---

## Recommendations

### High Priority
**None** - Current implementation is excellent.

### Medium Priority
1. **Extract parameter methods for consistency:**
   - Create `session_params`, `password_params`, etc. methods
   - Use strong parameters consistently across all controllers

2. **Consider using `params.expect()` (Rails 8.1+):**
   - Better error messages
   - More explicit parameter requirements

### Low Priority
3. **Add error handling for common exceptions:**
   - `ActiveRecord::RecordNotFound`
   - `ActiveRecord::RecordInvalid`
   - Other application-specific errors

4. **Consider using `around_action` for logging:**
   - Log request/response times
   - Track controller action performance

---

## Conclusion

The application demonstrates **excellent** controller practices:

✅ **Strengths:**
- Proper controller structure and inheritance
- Strong parameters usage (with minor inconsistencies)
- Secure session management
- Appropriate use of controller callbacks
- Good flash message handling
- Security-conscious implementation
- Rate limiting on sensitive endpoints

⚠️ **Minor Enhancements:**
- Extract parameter methods for consistency
- Consider using `params.expect()` for better error handling
- Add error handling for common exceptions

**Overall:** The controller implementation aligns well with Rails best practices and the Action Controller Overview guide. The code is clean, secure, and follows Rails conventions.

---

## Implementation Notes

### Current Controller Summary

1. **ApplicationController**
   - Base controller with authentication
   - Helper methods for views
   - Error handling (CanCan)

2. **SessionsController**
   - Login/logout functionality
   - Session management
   - Rate limiting

3. **RegistrationsController**
   - User signup
   - Account updates
   - Strong parameters

4. **PasswordsController**
   - Password reset flow
   - Token validation
   - Security-conscious messaging

5. **ConfirmationsController**
   - Email confirmation
   - Resend confirmation
   - Token validation

6. **UnlocksController**
   - Account unlocking
   - Resend unlock instructions
   - Security-conscious messaging

7. **DocsController**
   - Serves static documentation
   - Conditional GET support
   - Cache headers

All controllers follow Rails conventions and best practices.
