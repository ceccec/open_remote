# User

# User model with Devise-like authentication features.

**Type:** Models  
**File:** `user.rb`


## Included Modules

- `User::Confirmable`
- `User::Recoverable`
- `User::Rememberable`
- `User::Lockable`



## Methods

- `_run_create_callbacks`
- `_run_destroy_callbacks`
- `_run_rollback_callbacks`
- `_run_save_callbacks`
- `_run_touch_callbacks`
- `_run_update_callbacks`
- `admin?`
- `autosave_associated_records_for_roles`
- `autosave_associated_records_for_roles_users`
- `autosave_associated_records_for_versions`
- `find_by_confirmation_token`
- `find_by_password_reset_token`
- `find_by_password_reset_token!`
- `find_by_remember_token`
- `find_by_reset_password_token`
- `find_by_unlock_token`
- `make_admin!`
- `paper_trail_event`
- `paper_trail_event=`
- `paper_trail_options`
- `paper_trail_options=`
- `paper_trail_options?`
- `password_reset_token_expires_in`
- `remove_admin!`
- `validate_associated_records_for_roles`
- `validate_associated_records_for_roles_users`
- `validate_associated_records_for_versions`
- `version`
- `version=`
- `version_association_name`
- `version_association_name=`
- `version_association_name?`
- `version_class_name`
- `version_class_name=`
- `version_class_name?`
- `versions_association_name`
- `versions_association_name=`
- `versions_association_name?`


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


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/user.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb`

---

[← Back to Index](/)
