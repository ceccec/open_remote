# ApplicationController Examples

Test-driven examples for ApplicationController functionality.

### returns nil and false when there is no user in the session

```ruby
      expect(controller.send(:current_user)).to be_nil
      expect(controller.send(:logged_in?)).to be(false)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/application_controller_spec.rb:19`_


---

### returns the user and true when a user id is stored in the session

```ruby
      expect(controller.send(:current_user)).to eq(user)
      expect(controller.send(:logged_in?)).to be(true)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/application_controller_spec.rb:25`_


---

### redirects to login when not logged in

```ruby
      expect(response).to redirect_to("/login")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/application_controller_spec.rb:42`_


---

### allows request when logged in

```ruby
      expect(response).to have_http_status(:ok)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/application_controller_spec.rb:47`_


---

### redirects to login when current_user is not an admin

```ruby
      expect(response).to redirect_to("/login")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/application_controller_spec.rb:63`_


---

### allows request when current_user is an admin

```ruby
      expect(response).to have_http_status(:ok)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/application_controller_spec.rb:75`_


---

[← Back to Index](/)
