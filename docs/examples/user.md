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

### returns false

```ruby
        expect(user.remember_token_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:70`_


---

### returns false

```ruby
        expect(user.remember_token_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:70`_


---

### returns false

```ruby
        expect(user.remember_token_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:70`_


---

### ensures default roles exist

```ruby
      expect(names).to contain_exactly("admin", "manager", "viewer")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:5`_


---

### does not create duplicate roles when called multiple times

```ruby
      expect(counts_after).to eq(counts_before)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:11`_


---

### generates a password of default length (16)

```ruby
      expect(password.length).to eq(16)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:21`_


---

### generates a password of specified length

```ruby
      expect(password.length).to eq(20)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:26`_


---

### enforces minimum length of 12

```ruby
      expect(password.length).to eq(12)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:31`_


---

### includes at least one lowercase letter

```ruby
      expect(password).to match(/[a-z]/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:36`_


---

### includes at least one uppercase letter

```ruby
      expect(password).to match(/[A-Z]/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:41`_


---

### includes at least one number

```ruby
      expect(password).to match(/[0-9]/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:46`_


---

[← Back to Index](/)
