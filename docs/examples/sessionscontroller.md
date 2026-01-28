# SessionsController Examples

Test-driven examples for SessionsController functionality.

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:14`_


---

### creates a session and redirects

```ruby
        expect(session[:user_id]).to eq(user.id)
        expect(response).to have_http_status(:redirect)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:22`_


---

### does not create a session

```ruby
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:30`_


---

### does not create a session

```ruby
        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:30`_


---

### destroys the session and redirects

```ruby
      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:redirect)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/sessions_controller_spec.rb:51`_


---

[← Back to Index](/)
