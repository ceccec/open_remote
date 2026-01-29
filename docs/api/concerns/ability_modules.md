# AbilityModules

API documentation for AbilityModules

This model inherits from `ActiveRecord::Base`, providing database persistence, validations, associations, and callbacks. See [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) for the complete API.

**Rails Framework References:**
- **Base Class**: [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) - `has_many`, `belongs_to`, `has_one` relationships
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks
- **Query Interface**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)


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
