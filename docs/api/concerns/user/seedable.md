# User::Seedable

# Seed helpers for the `User` model.

**Type:** Concerns  
**File:** `user/seedable.rb`

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

- **Examples for this class**: 23
- **Test file**: `spec/models/concerns/user/seedable_spec.rb`
- **Last tested**: 2026-01-28 22:53:04

:::






## Methods

- `ensure_default_roles!`
- `ensure_super_admin!`
- `generate_secure_password`


## Examples

The following examples are extracted from test files:

### ensures default roles exist

```ruby
      expect(names).to contain_exactly("admin", "manager", "viewer")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:5`_


### does not create duplicate roles when called multiple times

```ruby
      expect(counts_after).to eq(counts_before)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:11`_


### generates a password of default length (16)

```ruby
      expect(password.length).to eq(16)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:21`_


### generates a password of specified length

```ruby
      expect(password.length).to eq(20)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:26`_


### enforces minimum length of 12

```ruby
      expect(password.length).to eq(12)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:31`_


### includes at least one lowercase letter

```ruby
      expect(password).to match(/[a-z]/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:36`_


### includes at least one uppercase letter

```ruby
      expect(password).to match(/[A-Z]/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:41`_


### includes at least one number

```ruby
      expect(password).to match(/[0-9]/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:46`_


### includes at least one special character

```ruby
      expect(password).to match(/[!@#\$%^&*\-_+=]/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:51`_


### generates different passwords each time

```ruby
      expect(passwords.uniq.length).to eq(10)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:56`_


### creates a new super admin user

```ruby
        expect do
        expect(@user.email).to eq(email)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:70`_


### sets admin flag to true

```ruby
        expect(user.admin).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:77`_


### assigns admin role

```ruby
        expect(user.has_role?(:admin)).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:82`_


### confirms the user

```ruby
        expect(user.confirmed?).to be_truthy
        expect(user.confirmed_at).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:87`_


### unlocks the account

```ruby
        expect(user.locked_at).to be_nil
        expect(user.failed_attempts).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:93`_


### generates a password if none provided

```ruby
        expect(user.password_digest).to be_present
        expect(user.seed_password_to_set).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:99`_


### uses provided password if given

```ruby
        expect(user.authenticate("custom123")).to eq(user)
        expect(user.seed_password_to_set).to eq("custom123")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:105`_


### does not change password unless explicitly provided

```ruby
        expect(user.password_digest).to eq(old_digest)
        expect(user.seed_password_to_set).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:122`_


### updates password if explicitly provided

```ruby
        expect(user.authenticate("newpassword")).to eq(user)
        expect(user.seed_password_to_set).to eq("newpassword")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:129`_


### sets admin flag to true

```ruby
        expect(user.admin).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb:77`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/concerns/user/seedable.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/seedable_spec.rb`

---

[← Back to Index](/)
