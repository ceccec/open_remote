# SessionsController

# Session controller with Devise-like features.

**Type:** Controllers  
**File:** `sessions_controller.rb`




## Methods

### `new`




### `create`




### `destroy`




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
