# SessionsController

# Session controller with Devise-like features.

**Type:** Controllers  
**File:** `sessions_controller.rb`

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

- **Examples for this class**: 5
- **Test file**: `spec/controllers/sessions_controller_spec.rb`
- **Last tested**: 2026-01-28 16:12:47

:::






## Methods

- `create`
- `destroy`
- `new`


## Examples

The following examples are extracted from test files:

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:14`_


### creates a session and redirects

```ruby
        expect(session[:user_id]).to eq(user.id)
        expect(response).to have_http_status(:redirect)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:22`_


### does not create a session

```ruby
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:30`_


### does not create a session

```ruby
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:30`_


### destroys the session and redirects

```ruby
      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:redirect)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:51`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/controllers/sessions_controller.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb`

---

[← Back to Index](/)
