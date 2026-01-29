# UnlocksController

# Account unlock controller.

**Type:** Controllers  
**File:** `unlocks_controller.rb`
<Badge type="warning" text="File Coverage: 33.33%" />
<Badge type="info" text="6/51 lines" />


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
- **Test file**: `spec/controllers/unlocks_controller_spec.rb`
- **Last tested**: 2026-01-29 03:27:01

:::






## Methods

- `create`
  <Badge type="warning" text="Coverage: 11.11%" />
  <small>Uncovered lines: 41, 42, 43, 44, 45...</small>
- `new`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - redirects to new unlock path with alert
  - redirects to new unlock path with alert
  - redirects to new unlock path with alert

- `show`
  <Badge type="warning" text="Coverage: 11.11%" />
  <small>Uncovered lines: 16, 17, 18, 19, 20...</small>


## Examples

The following examples are extracted from test files:

### unlocks the account and redirects to login

```ruby
        expect(user.locked_at).to be_nil
        expect(user.failed_attempts).to eq(0)
        expect(user.unlock_token).to be_nil
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Your account has been unlocked. You can now log in.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:21`_


### redirects to new unlock path with alert

```ruby
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:33`_


### redirects to new unlock path with alert

```ruby
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:33`_


### redirects to new unlock path with alert

```ruby
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:33`_


### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:72`_


### sends unlock instructions and redirects

```ruby
        expect(UserMailer).to receive(:with).with(user: user).and_return(mailer_double)
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Unlock instructions have been sent to your email.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:84`_


### redirects without revealing account status

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists and is locked, unlock instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:95`_


### redirects without revealing email existence

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists and is locked, unlock instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:103`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/controllers/unlocks_controller.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb`

---

[← Back to Index](/)
