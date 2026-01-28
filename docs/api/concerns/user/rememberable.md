# User::Rememberable

# Remember me functionality.

**Type:** Concerns  
**File:** `user/rememberable.rb`




## Methods

- `forget_me!`
- `generate_remember_token!`
- `remember_me!`
- `remember_token_valid?`

  **Examples:**
  - returns true
  - returns false
  - returns false
  - returns false


## Examples

The following examples are extracted from test files:

### generates a remember token

```ruby
      expect(user.remember_token).to be_nil
      expect(user.remember_token).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:12`_


### sets remember_created_at

```ruby
      expect(user.remember_created_at).to be_nil
      expect(user.remember_created_at).to be_within(1.second).of(Time.current)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:18`_


### returns the remember token

```ruby
      expect(token).to eq(user.remember_token)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:24`_


### generates a unique token

```ruby
      expect(user1.remember_token).not_to eq(user2.remember_token)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:29`_


### clears the remember token

```ruby
      expect(user.remember_token).to be_present
      expect(user.remember_token).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:43`_


### clears remember_created_at

```ruby
      expect(user.remember_created_at).to be_present
      expect(user.remember_created_at).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:50`_


### returns true

```ruby
        expect(user.remember_token_valid?).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:64`_


### returns false

```ruby
        expect(user.remember_token_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:70`_


### returns false

```ruby
        expect(user.remember_token_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:70`_


### returns false

```ruby
        expect(user.remember_token_valid?).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb:70`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/concerns/user/rememberable.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/user/rememberable_spec.rb`

---

[← Back to Index](/)
