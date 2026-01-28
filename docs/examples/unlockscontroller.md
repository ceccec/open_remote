# UnlocksController Examples

Test-driven examples for UnlocksController functionality.

### unlocks the account and redirects to login

```ruby
        expect(user.locked_at).to be_nil
        expect(user.failed_attempts).to eq(0)
        expect(user.unlock_token).to be_nil
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Your account has been unlocked. You can now log in.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:21`_


---

### redirects to new unlock path with alert

```ruby
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:33`_


---

### redirects to new unlock path with alert

```ruby
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:33`_


---

### redirects to new unlock path with alert

```ruby
        expect(response).to redirect_to("/unlock/new")
        expect(flash[:alert]).to eq("Unlock token is invalid or account is not locked.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:33`_


---

### returns success

```ruby
      expect(response).to have_http_status(:success)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:72`_


---

### sends unlock instructions and redirects

```ruby
        expect(UserMailer).to receive(:unlock_instructions).with(user).and_return(double(deliver_later: true))
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("Unlock instructions have been sent to your email.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:84`_


---

### redirects without revealing account status

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists and is locked, unlock instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:93`_


---

### redirects without revealing email existence

```ruby
        expect(response).to redirect_to("/login")
        expect(flash[:notice]).to eq("If an account exists and is locked, unlock instructions have been sent.")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/unlocks_controller_spec.rb:101`_


---

[← Back to Index](/)
