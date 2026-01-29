# ConfirmationsController

# Email confirmation controller.

**Type:** Controllers  
**File:** `confirmations_controller.rb`

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

- **Examples for this class**: 8
- **Test file**: `spec/controllers/confirmations_controller_spec.rb`
- **Last tested**: 2026-01-28 22:12:18

:::






## Methods

- `create`
- `new`

  **Examples:**
  - redirects to new confirmation path with alert
  - redirects to new confirmation path with alert
  - redirects to new confirmation path with alert

- `show`


## Examples

The following examples are extracted from test files:

### confirms the user and redirects to login

```ruby
        expect(user.confirmed?).to be(true)
        expect(user.confirmation_token).to be_nil
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Your email has been confirmed. You can now log in.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:21`_


### redirects to new confirmation path with alert

```ruby
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:32`_


### redirects to new confirmation path with alert

```ruby
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:32`_


### redirects to new confirmation path with alert

```ruby
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:32`_


### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:71`_


### sends confirmation instructions and redirects

```ruby
        expect(UserMailer).to receive(:confirmation_instructions).with(user).and_return(double(deliver_later: true))
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Confirmation instructions have been sent to your email.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:83`_


### redirects to login with notice

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Email already confirmed. You can log in.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:96`_


### redirects to login without revealing email existence

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists with that email, confirmation instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:104`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/controllers/confirmations_controller.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb`

---

[← Back to Index](/)
