# User Examples

Test-driven examples for User functionality.

### is valid with valid attributes

```ruby
      expect(user).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:5`_


---

### is invalid without email

```ruby
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:15`_


---

### is invalid with duplicate email

```ruby
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:21`_


---

### is invalid with invalid email format

```ruby
      expect(user).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:28`_


---

### is invalid with password shorter than 6 characters

```ruby
      expect(user).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:33`_


---

### authenticates with correct password

```ruby
      expect(user.authenticate("password123")).to eq(user)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:40`_


---

### does not authenticate with incorrect password

```ruby
      expect(user.authenticate("wrongpassword")).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:49`_


---

### defaults to false

```ruby
      expect(user.admin).to be_falsey
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:60`_


---

### can be set to true

```ruby
      expect(user.admin).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/user_spec.rb:68`_


---

[← Back to Index](/)
