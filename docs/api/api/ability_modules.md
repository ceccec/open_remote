# AbilityModules

API documentation for AbilityModules

## Examples

The following examples are extracted from test files:

### defines manage all permissions

```ruby
      expect(ability).to be_able_to(:manage, :all)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:15`_


### allows access to all models

```ruby
      expect(ability).to be_able_to(:manage, Asset)
      expect(ability).to be_able_to(:manage, AssetType)
      expect(ability).to be_able_to(:manage, Rule)
      expect(ability).to be_able_to(:manage, DataPoint)
      expect(ability).to be_able_to(:manage, Notification)
      expect(ability).to be_able_to(:manage, RuleExecution)
      expect(ability).to be_able_to(:manage, User)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:20`_


### defines no permissions

```ruby
      expect(ability).not_to be_able_to(:manage, :all)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:42`_


### denies access to all models

```ruby
      expect(ability).not_to be_able_to(:manage, Asset)
      expect(ability).not_to be_able_to(:manage, AssetType)
      expect(ability).not_to be_able_to(:manage, Rule)
      expect(ability).not_to be_able_to(:manage, DataPoint)
      expect(ability).not_to be_able_to(:manage, Notification)
      expect(ability).not_to be_able_to(:manage, RuleExecution)
      expect(ability).not_to be_able_to(:manage, User)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:47`_


### grants RailsAdmin access

```ruby
      expect(ability).to be_able_to(:access, :rails_admin)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:71`_


### allows managing assets, rules, and data

```ruby
      expect(ability).to be_able_to(:manage, Asset)
      expect(ability).to be_able_to(:manage, AssetType)
      expect(ability).to be_able_to(:manage, Rule)
      expect(ability).to be_able_to(:manage, RuleExecution)
      expect(ability).to be_able_to(:manage, DataPoint)
      expect(ability).to be_able_to(:manage, Notification)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:76`_


### does not allow managing users

```ruby
      expect(ability).not_to be_able_to(:manage, User)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:86`_


### denies RailsAdmin access

```ruby
      expect(ability).not_to be_able_to(:access, :rails_admin)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:104`_


### denies managing anything

```ruby
      expect(ability).not_to be_able_to(:manage, :all)
      expect(ability).not_to be_able_to(:manage, Asset)
      expect(ability).not_to be_able_to(:manage, Rule)
      expect(ability).not_to be_able_to(:manage, User)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:109`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb`

---

[← Back to Index](/)
