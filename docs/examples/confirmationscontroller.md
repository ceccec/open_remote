# ConfirmationsController Examples

Test-driven examples for ConfirmationsController functionality.

### confirms the user and redirects to login

```ruby
        expect(user.confirmed?).to be(true)
        expect(user.confirmation_token).to be_nil
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Your email has been confirmed. You can now log in.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:21`_


---

### redirects to new confirmation path with alert

```ruby
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:32`_


---

### redirects to new confirmation path with alert

```ruby
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:32`_


---

### redirects to new confirmation path with alert

```ruby
        expect(response).to redirect_to("/confirmation/new")
        expect(flash[:alert]).to eq("Confirmation token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:32`_


---

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:71`_


---

### sends confirmation instructions and redirects

```ruby
        expect(UserMailer).to receive(:with).with(user: user).and_return(mailer_double)
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Confirmation instructions have been sent to your email.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:83`_


---

### redirects to login with notice

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Email already confirmed. You can log in.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:98`_


---

### redirects to login without revealing email existence

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists with that email, confirmation instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/confirmations_controller_spec.rb:106`_


---

[← Back to Index](/)
