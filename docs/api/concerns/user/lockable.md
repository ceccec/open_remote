# User::Lockable

# Account locking functionality.

**Type:** Concerns  
**File:** `user/lockable.rb`

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
- **Test file**: `spec/models/concerns/user/lockable_spec.rb`
- **Last tested**: 2026-01-28 22:57:04

:::






## Methods

- `access_locked?`

  **Examples:**
  - returns false when not locked
  - returns true when locked and lock not expired
  - returns false when lock has expired
  - locks account after maximum failed attempts
  - locks the account

- `generate_unlock_token!`
- `increment_failed_attempts!`
- `lock_access!`
- `lock_expired?`
- `reset_failed_attempts!`
- `send_unlock_instructions`
- `unlock_access!`


## Examples

The following examples are extracted from test files:

### returns false when not locked

```ruby
      expect(user.access_locked?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:12`_


### returns true when locked and lock not expired

```ruby
      expect(user.access_locked?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:16`_


### returns false when lock has expired

```ruby
      expect(user.access_locked?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:21`_


### increments failed attempts

```ruby
      expect(user.failed_attempts).to eq(0)
      expect(user.failed_attempts).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:28`_


### does not increment if already locked

```ruby
      expect(user.failed_attempts).to eq(initial_attempts)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:34`_


### locks account after maximum failed attempts

```ruby
      expect(user.access_locked?).to be_truthy
      expect(user.failed_attempts).to eq(5)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:41`_


### locks the account

```ruby
      expect(user.access_locked?).to be_truthy
      expect(user.failed_attempts).to eq(5)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:50`_


### unlocks the account

```ruby
      expect(user.access_locked?).to be_falsey
      expect(user.failed_attempts).to eq(0)
      expect(user.unlock_token).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:62`_


### generates unlock token and sends email

```ruby
      expect do
        expect(token).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:75`_


### resets attempts when account is locked

```ruby
      expect(user.failed_attempts).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:84`_


### generates a unique token even if collision occurs

```ruby
      expect(user.unlock_token).to eq("unique-token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb:92`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/concerns/user/lockable.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/lockable_spec.rb`

---

[← Back to Index](/)
