# User::Confirmable

# Email confirmation functionality.

**Type:** Concerns  
**File:** `user/confirmable.rb`
<Badge type="warning" text="File Coverage: 50.0%" />
<Badge type="info" text="14/86 lines" />


This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.
**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior


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
- **Test file**: `spec/models/concerns/user/confirmable_spec.rb`
- **Last tested**: 2026-01-28 22:57:04

:::






## Methods

- `confirm!`
  <Badge type="warning" text="Coverage: 16.67%" />
  <small>Uncovered lines: 35, 36, 37, 38, 39</small>

  **Examples:**
  - is idempotent

- `confirmation_period_valid?`
  <Badge type="warning" text="Coverage: 33.33%" />
  <small>Uncovered lines: 60, 61</small>

  **Examples:**
  - returns false when confirmation_sent_at is nil
  - returns true when sent within 24 hours
  - returns false when sent more than 24 hours ago

- `confirmed?`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - returns false when not confirmed
  - returns true when confirmed_at is present
  - marks user as confirmed

- `generate_confirmation_token`
  <Badge type="tip" text="Coverage: 100.0%" />
- `generate_confirmation_token!`
  <Badge type="warning" text="Coverage: 20.0%" />
  <small>Uncovered lines: 80, 81, 82, 83</small>
- `send_confirmation_instructions`
  <Badge type="warning" text="Coverage: 25.0%" />
  <small>Uncovered lines: 48, 49, 50</small>


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
