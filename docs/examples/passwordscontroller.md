# PasswordsController Examples

Test-driven examples for PasswordsController functionality.

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:13`_


---

### sends reset password instructions and redirects

```ruby
        expect(UserMailer).to receive(:with).with(user: user).and_return(mailer_double)
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Password reset instructions have been sent to your email.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:21`_


---

### redirects without revealing email existence

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists with that email, password reset instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:32`_


---

### returns success

```ruby
        expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:49`_


---

### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:56`_


---

### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:56`_


---

### resets password and redirects to login

```ruby
        expect(user.reset_password_token).to be_nil
        expect(user.authenticate("newpassword123")).to eq(user)
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Password has been reset successfully.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:88`_


---

### returns unprocessable content status

```ruby
        expect(response).to have_http_status(:unprocessable_content)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:112`_


---

### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:56`_


---

### redirects to new password path with alert

```ruby
        expect(response).to redirect_to("/password/new")
        expect(flash[:alert]).to eq("Password reset token is invalid or has expired.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/passwords_controller_spec.rb:56`_


---

[← Back to Index](/)
