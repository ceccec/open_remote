# User Examples

Test-driven examples for User functionality.

### returns false when not confirmed

```ruby
      expect(user.confirmed?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:12`_


---

### returns true when confirmed_at is present

```ruby
      expect(user.confirmed?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:16`_


---

### marks user as confirmed

```ruby
      expect(user.confirmed?).to be_falsey
      expect(user.confirmed?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:23`_


---

### clears confirmation_token

```ruby
      expect(user.confirmation_token).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:29`_


---

### is idempotent

```ruby
      expect { user.confirm! }.not_to change { user.confirmed_at }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:35`_


---

### generates token and sends email

```ruby
      expect do
      expect(user.confirmation_token).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:42`_


---

### updates confirmation_sent_at

```ruby
      expect(user.confirmation_sent_at).to be_within(1.second).of(Time.current)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:49`_


---

### returns false when confirmation_sent_at is nil

```ruby
      expect(user.confirmation_period_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:56`_


---

### returns true when sent within 24 hours

```ruby
      expect(user.confirmation_period_valid?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:60`_


---

### returns false when sent more than 24 hours ago

```ruby
      expect(user.confirmation_period_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:65`_


---

### generates a unique token even if collision occurs

```ruby
      expect(user.confirmation_token).to eq("unique-token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:72`_


---

### returns false when not locked

```ruby
      expect(user.access_locked?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:12`_


---

### returns true when locked and lock not expired

```ruby
      expect(user.access_locked?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:16`_


---

### returns false when lock has expired

```ruby
      expect(user.access_locked?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:21`_


---

### increments failed attempts

```ruby
      expect(user.failed_attempts).to eq(0)
      expect(user.failed_attempts).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:28`_


---

### does not increment if already locked

```ruby
      expect(user.failed_attempts).to eq(initial_attempts)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:34`_


---

### locks account after maximum failed attempts

```ruby
      expect(user.access_locked?).to be_truthy
      expect(user.failed_attempts).to eq(5)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:41`_


---

### locks the account

```ruby
      expect(user.access_locked?).to be_truthy
      expect(user.failed_attempts).to eq(5)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:50`_


---

### unlocks the account

```ruby
      expect(user.access_locked?).to be_falsey
      expect(user.failed_attempts).to eq(0)
      expect(user.unlock_token).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:62`_


---

### generates unlock token and sends email

```ruby
      expect do
        expect(token).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:75`_


---

### resets attempts when account is locked

```ruby
      expect(user.failed_attempts).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:84`_


---

### generates a unique token even if collision occurs

```ruby
      expect(user.unlock_token).to eq("unique-token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:92`_


---

### generates reset token and sends email

```ruby
      expect do
      expect(user.reset_password_token).to be_present
      expect(user.reset_password_sent_at).to be_within(1.second).of(Time.current)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:14`_


---

### generates unique token even if collision occurs

```ruby
      expect(user.reset_password_token).to eq("unique-token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:23`_


---

### resets password with valid token

```ruby
      expect(result).to be true
      expect(user.reset_password_token).to be_nil
      expect(user.authenticate("new_password_123")).to eq(user)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:41`_


---

### returns false with invalid password confirmation

```ruby
      expect(result).to be false
      expect(user.reset_password_token).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:52`_


---

### returns false when token is expired

```ruby
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:62`_


---

### returns false when token is missing

```ruby
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:73`_


---

### returns true when token is valid and not expired

```ruby
      expect(user.reset_password_period_valid?).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:86`_


---

### returns false when token is missing

```ruby
      expect(user.reset_password_period_valid?).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:73`_


---

### returns false when sent_at is missing

```ruby
      expect(user.reset_password_period_valid?).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:95`_


---

### returns false when token is expired (>6 hours)

```ruby
      expect(user.reset_password_period_valid?).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:101`_


---

### returns true when token is within 6 hours

```ruby
      expect(user.reset_password_period_valid?).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:107`_


---

### generates a remember token

```ruby
      expect(user.remember_token).to be_nil
      expect(user.remember_token).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:12`_


---

### sets remember_created_at

```ruby
      expect(user.remember_created_at).to be_nil
      expect(user.remember_created_at).to be_within(1.second).of(Time.current)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:18`_


---

### returns the remember token

```ruby
      expect(token).to eq(user.remember_token)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:24`_


---

### generates a unique token

```ruby
      expect(user1.remember_token).not_to eq(user2.remember_token)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:29`_


---

### clears the remember token

```ruby
      expect(user.remember_token).to be_present
      expect(user.remember_token).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:43`_


---

### clears remember_created_at

```ruby
      expect(user.remember_created_at).to be_present
      expect(user.remember_created_at).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:50`_


---

### returns true

```ruby
        expect(user.remember_token_valid?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:64`_


---

[← Back to Index](/)
