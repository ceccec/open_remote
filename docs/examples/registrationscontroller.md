# RegistrationsController Examples

Test-driven examples for RegistrationsController functionality.

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:13`_


---

### creates user and sends confirmation instructions

```ruby
        expect(created_user).to be_present
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Registration successful! Please check your email to confirm your account.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:21`_


---

### returns unprocessable content status

```ruby
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:40`_


---

### returns unprocessable content status

```ruby
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:40`_


---

### requires authentication

```ruby
      expect { get :edit }.to raise_error(ActionController::MissingExactTemplate)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:71`_


---

### updates user and redirects

```ruby
        expect(user.email).to eq("updated@example.com")
        expect(user.authenticate("newpassword123")).to eq(user)
        expect(response).to redirect_to("/")
        expect(flash[:notice]).to eq("Account updated successfully.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:84`_


---

### raises error due to missing template

```ruby
        expect {
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:101`_


---

### updates email only

```ruby
        expect(user.email).to eq("updated@example.com")
        expect(user.authenticate("password123")).to eq(user)
        expect(response).to redirect_to("/")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/registrations_controller_spec.rb:115`_


---

[← Back to Index](/)
