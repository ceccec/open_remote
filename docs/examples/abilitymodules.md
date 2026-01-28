# AbilityModules Examples

Test-driven examples for AbilityModules functionality.

### defines manage all permissions

```ruby
      expect(ability).to be_able_to(:manage, :all)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:15`_


---

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


---

### defines no permissions

```ruby
      expect(ability).not_to be_able_to(:manage, :all)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_modules_spec.rb:42`_


---

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


---

[← Back to Index](/)
