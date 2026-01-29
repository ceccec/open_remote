# PasswordsController

# Password reset controller.

**Type:** Controllers  
**File:** `passwords_controller.rb`

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
- **Last tested**: 2026-01-28 22:12:25

:::






## Methods

- `create`
- `edit`
- `new`

  **Examples:**
  - redirects to new password path with alert
  - redirects to new password path with alert
  - resets password and redirects to login
  - redirects to new password path with alert
  - redirects to new password path with alert

- `update`


## Examples

The following examples are extracted from test files:

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:13`_


### sends reset password instructions and redirects

```ruby
        expect(UserMailer).to receive(:reset_password_instructions).with(user).and_return(double(deliver_later: true))
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Password reset instructions have been sent to your email.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:21`_


### redirects without revealing email existence

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists with that email, password reset instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:30`_


### returns success

```ruby
        expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:47`_


### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:54`_


### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:54`_


### resets password and redirects to login

```ruby
        expect(user.reset_password_token).to be_nil
        expect(user.authenticate("newpassword123")).to eq(user)
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Password has been reset successfully.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:86`_


### returns unprocessable content status

```ruby
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:110`_


### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:54`_


### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:54`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/controllers/passwords_controller.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb`

---

[← Back to Index](/)
