# User::Confirmable

# Email confirmation functionality.

**Type:** Concerns  
**File:** `user/confirmable.rb`




## Methods

- `confirm!`

  **Examples:**
  - is idempotent

- `confirmation_period_valid?`

  **Examples:**
  - returns false when confirmation_sent_at is nil
  - returns true when sent within 24 hours
  - returns false when sent more than 24 hours ago

- `confirmed?`

  **Examples:**
  - returns false when not confirmed
  - returns true when confirmed_at is present
  - marks user as confirmed

- `generate_confirmation_token`
- `generate_confirmation_token!`
- `send_confirmation_instructions`


## Examples

The following examples are extracted from test files:

### returns false when not confirmed

```ruby
      expect(user.confirmed?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:12`_


### returns true when confirmed_at is present

```ruby
      expect(user.confirmed?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:16`_


### marks user as confirmed

```ruby
      expect(user.confirmed?).to be_falsey
      expect(user.confirmed?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:23`_


### clears confirmation_token

```ruby
      expect(user.confirmation_token).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:29`_


### is idempotent

```ruby
      expect { user.confirm! }.not_to change { user.confirmed_at }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:35`_


### generates token and sends email

```ruby
      expect do
      expect(user.confirmation_token).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:42`_


### updates confirmation_sent_at

```ruby
      expect(user.confirmation_sent_at).to be_within(1.second).of(Time.current)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:49`_


### returns false when confirmation_sent_at is nil

```ruby
      expect(user.confirmation_period_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:56`_


### returns true when sent within 24 hours

```ruby
      expect(user.confirmation_period_valid?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:60`_


### returns false when sent more than 24 hours ago

```ruby
      expect(user.confirmation_period_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:65`_


### generates a unique token even if collision occurs

```ruby
      expect(user.confirmation_token).to eq("unique-token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb:72`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/concerns/user/confirmable.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/confirmable_spec.rb`

---

[← Back to Index](/)
