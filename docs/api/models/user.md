# User

# User model with Devise-like authentication features.

**Type:** Models  
**File:** `user.rb`
<Badge type="warning" text="File Coverage: 75.68%" />
<Badge type="info" text="28/106 lines" />


This model inherits from `ApplicationRecord`, providing database persistence, validations, callbacks, query methods, and more. See [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) - Database persistence, querying, and model lifecycle
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks (`before_save`, `after_create`, etc.)
- **Query Methods**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)
- **Querying**: [ActiveRecord::Querying](https://api.rubyonrails.org/classes/ActiveRecord/Querying.html) - Query interface and finder methods
- **Persistence**: [ActiveRecord::Persistence](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html) - `save`, `create`, `update`, `destroy` methods
- **ActiveRecord Module**: [ActiveRecord](https://api.rubyonrails.org/classes/ActiveRecord.html) - Complete API reference


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

- **Examples for this class**: 15
- **Test file**: `spec/models/user_spec.rb`
- **Last tested**: 2026-01-28 22:57:04

:::




## Included Modules

These modules extend the class with additional behavior. Concerns use [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for modular functionality.

- `TestExpectations` - Provides additional functionality
- `User::Confirmable` - Provides additional functionality
- `User::Recoverable` - Provides additional functionality
- `User::Rememberable` - Provides additional functionality
- `User::Lockable` - Provides additional functionality
- `User::Seedable` - Provides additional functionality



## Methods

- `admin?`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - returns true when admin flag is true
  - returns true when user has admin role but flag is false

- `find_by_confirmation_token`
  <Badge type="tip" text="Coverage: 100.0%" />
- `find_by_remember_token`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - returns nil when token is blank

- `find_by_reset_password_token`
  <Badge type="tip" text="Coverage: 100.0%" />
- `find_by_unlock_token`
  <Badge type="tip" text="Coverage: 100.0%" />
- `make_admin!`
  <Badge type="warning" text="Coverage: 50.0%" />
  <small>Uncovered lines: 94</small>
- `remove_admin!`
  <Badge type="warning" text="Coverage: 50.0%" />
  <small>Uncovered lines: 103</small>


## Examples

The following examples are extracted from test files:

### is valid with valid attributes

```ruby
      expect(user).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:5`_


### is invalid without email

```ruby
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:15`_


### is invalid with duplicate email

```ruby
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:21`_


### is invalid with invalid email format

```ruby
      expect(user).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:28`_


### is invalid with password shorter than 6 characters

```ruby
      expect(user).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:33`_


### authenticates with correct password

```ruby
      expect(user.authenticate("password123")).to eq(user)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:40`_


### does not authenticate with incorrect password

```ruby
      expect(user.authenticate("wrongpassword")).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:49`_


### defaults to false

```ruby
      expect(user.admin).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:60`_


### can be set to true

```ruby
      expect(user.admin).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:68`_


### returns true when admin flag is true

```ruby
      expect(user.admin?).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:79`_


### returns true when user has admin role but flag is false

```ruby
      expect(user.admin?).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:84`_


### adds admin role and sets admin flag

```ruby
      expect(user.admin).to be true
      expect(user.has_role?(:admin)).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:92`_


### removes admin role and clears admin flag

```ruby
      expect(user.admin).to be false
      expect(user.has_role?(:admin)).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:102`_


### returns nil when token is blank

```ruby
      expect(User.find_by_remember_token(nil)).to be_nil
      expect(User.find_by_remember_token("")).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:115`_


### finds user by remember token when token is present

```ruby
      expect(found).to eq(user)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:120`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/user.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb`

---

[← Back to Index](/)
