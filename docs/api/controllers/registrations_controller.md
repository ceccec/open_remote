# RegistrationsController

# User registration controller.

**Type:** Controllers  
**File:** `registrations_controller.rb`

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
- **Test file**: `spec/controllers/registrations_controller_spec.rb`
- **Last tested**: 2026-01-28 22:12:47

:::






## Methods

- `create`

  **Examples:**
  - creates user and sends confirmation instructions

- `edit`

  **Examples:**
  - requires authentication

- `new`

  **Examples:**
  - updates user and redirects

- `update`

  **Examples:**
  - updates user and redirects
  - updates email only

- `user_params`
- `user_update_params`


## Examples

The following examples are extracted from test files:

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:13`_


### creates user and sends confirmation instructions

```ruby
        expect(UserMailer).to receive(:confirmation_instructions).and_return(double(deliver_later: true))
        expect(created_user).to be_present
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Registration successful! Please check your email to confirm your account.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:21`_


### returns unprocessable content status

```ruby
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:38`_


### returns unprocessable content status

```ruby
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:38`_


### requires authentication

```ruby
      expect { get :edit }.to raise_error(ActionController::MissingExactTemplate)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:69`_


### updates user and redirects

```ruby
        expect(user.email).to eq("updated@example.com")
        expect(user.authenticate("newpassword123")).to eq(user)
        expect(response).to redirect_to("/")
        expect(flash[:notice]).to eq("Account updated successfully.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:82`_


### raises error due to missing template

```ruby
        expect {
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:99`_


### updates email only

```ruby
        expect(user.email).to eq("updated@example.com")
        expect(user.authenticate("password123")).to eq(user)
        expect(response).to redirect_to("/")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:113`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/controllers/registrations_controller.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb`

---

[← Back to Index](/)
