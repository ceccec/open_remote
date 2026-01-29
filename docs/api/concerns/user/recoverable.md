# User::Recoverable

# Password recovery functionality.

**Type:** Concerns  
**File:** `user/recoverable.rb`

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns


::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 11
- **Test file**: `spec/models/concerns/user/recoverable_spec.rb`
- **Last tested**: 2026-01-28 23:11:20

:::






## Methods

- `generate_reset_password_token!`
- `reset_password`

  **Examples:**
  - generates reset token and sends email
  - generates unique token even if collision occurs
  - resets password with valid token
  - returns false with invalid password confirmation
  - returns true when token is valid and not expired

- `reset_password_period_valid?`

  **Examples:**
  - returns true when token is valid and not expired
  - returns false when token is missing
  - returns false when sent_at is missing
  - returns false when token is expired (>6 hours)
  - returns true when token is within 6 hours

- `send_reset_password_instructions`


## Examples

The following examples are extracted from test files:

### generates reset token and sends email

```ruby
      expect do
      expect(user.reset_password_token).to be_present
      expect(user.reset_password_sent_at).to be_within(1.second).of(Time.current)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:14`_


### generates unique token even if collision occurs

```ruby
      expect(user.reset_password_token).to eq("unique-token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:23`_


### resets password with valid token

```ruby
      expect(result).to be true
      expect(user.reset_password_token).to be_nil
      expect(user.authenticate("new_password_123")).to eq(user)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:41`_


### returns false with invalid password confirmation

```ruby
      expect(result).to be false
      expect(user.reset_password_token).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:52`_


### returns false when token is expired

```ruby
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:62`_


### returns false when token is missing

```ruby
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:73`_


### returns true when token is valid and not expired

```ruby
      expect(user.reset_password_period_valid?).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:86`_


### returns false when token is missing

```ruby
      expect(user.reset_password_period_valid?).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:73`_


### returns false when sent_at is missing

```ruby
      expect(user.reset_password_period_valid?).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:95`_


### returns false when token is expired (>6 hours)

```ruby
      expect(user.reset_password_period_valid?).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:101`_


### returns true when token is within 6 hours

```ruby
      expect(user.reset_password_period_valid?).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb:107`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/concerns/user/recoverable.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/recoverable_spec.rb`

---

[← Back to Index](/)
