# PasswordsController

# Password reset controller.

**Type:** Controllers  
**File:** `passwords_controller.rb`
<Badge type="warning" text="File Coverage: 28.0%" />
<Badge type="info" text="7/71 lines" />


This controller inherits from `ApplicationController`, handling HTTP requests, rendering, session management, strong parameters, filters, and more. See [ApplicationController](https://api.rubyonrails.org/classes/ApplicationController.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationController](https://api.rubyonrails.org/classes/ApplicationController.html) - Request handling, rendering, and controller lifecycle
- **Parameters**: [ActionController::Parameters](https://api.rubyonrails.org/classes/ActionController/Parameters.html) - Strong parameters and request data filtering
- **Routing**: [ActionDispatch::Routing](https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper.html) - URL routing and route helpers
- **Filters**: [ActionController::Filters](https://api.rubyonrails.org/classes/ActionController/Filters/ClassMethods.html) - `before_action`, `after_action`, `around_action`


::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 10
- **Test file**: `spec/controllers/passwords_controller_spec.rb`
- **Last tested**: 2026-01-29 03:27:01

:::






## Methods

- `create`
  <Badge type="warning" text="Coverage: 11.11%" />
  <small>Uncovered lines: 25, 26, 27, 28, 29...</small>
- `edit`
  <Badge type="warning" text="Coverage: 16.67%" />
  <small>Uncovered lines: 41, 42, 43, 44, 45</small>
- `new`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - redirects to new password path with alert
  - redirects to new password path with alert
  - resets password and redirects to login
  - redirects to new password path with alert
  - redirects to new password path with alert

- `update`
  <Badge type="warning" text="Coverage: 6.25%" />
  <small>Uncovered lines: 54, 55, 56, 57, 58...</small>


## Examples

The following examples are extracted from test files:

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:13`_


### sends reset password instructions and redirects

```ruby
        expect(UserMailer).to receive(:with).with(user: user).and_return(mailer_double)
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Password reset instructions have been sent to your email.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:21`_


### redirects without revealing email existence

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists with that email, password reset instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:32`_


### returns success

```ruby
        expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:49`_


### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:56`_


### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:56`_


### resets password and redirects to login

```ruby
        expect(user.reset_password_token).to be_nil
        expect(user.authenticate("newpassword123")).to eq(user)
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Password has been reset successfully.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:88`_


### returns unprocessable content status

```ruby
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:112`_


### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:56`_


### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:56`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/controllers/passwords_controller.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb`

---

[← Back to Index](/)
