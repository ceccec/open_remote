# BatchActions

# Provides batch action functionality for ActiveRecord models.

**Type:** Concerns  
**File:** `batch_actions.rb`

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

- **Examples for this class**: 24
- **Test file**: `spec/concerns/batch_actions_spec.rb`
- **Last tested**: 2026-01-29 00:23:39

:::






## Methods

- `batch_acknowledge`
- `batch_assign_parent`

  **Examples:**
  - assigns multiple assets to a parent
  - can make assets root by passing nil
  - returns the number of records updated

- `batch_delete`

  **Examples:**
  - deletes multiple records by ID
  - works with ActiveRecord::Relation
  - returns the number of records deleted

- `batch_disable`

  **Examples:**
  - disables multiple rules by ID
  - works with ActiveRecord::Relation
  - returns the number of records updated

- `batch_enable`

  **Examples:**
  - enables multiple rules by ID
  - does not affect other rules
  - works with ActiveRecord::Relation
  - returns the number of records updated

- `batch_execute`
- `batch_update`

  **Examples:**
  - updates multiple records with attributes
  - works with ActiveRecord::Relation
  - returns the number of records updated
  - returns 0 if attributes are blank


## Examples

The following examples are extracted from test files:

### enables multiple rules by ID

```ruby
        expect { Rule.batch_enable([ rule1.id, rule2.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:10`_


### does not affect other rules

```ruby
        expect { Rule.batch_enable([ rule1.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:16`_


### works with ActiveRecord::Relation

```ruby
        expect { Rule.batch_enable(Rule.disabled) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


### returns the number of records updated

```ruby
        expect(Rule.batch_enable([ rule1.id, rule2.id ])).to eq(2)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


### disables multiple rules by ID

```ruby
        expect { Rule.batch_disable([ rule3.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:32`_


### works with ActiveRecord::Relation

```ruby
        expect { Rule.batch_disable(Rule.enabled) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


### returns the number of records updated

```ruby
        expect(Rule.batch_disable([ rule3.id ])).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


### updates multiple records with attributes

```ruby
        expect { Rule.batch_update([ rule1.id, rule2.id ], { timezone: "UTC" }) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:48`_


### works with ActiveRecord::Relation

```ruby
        expect { Rule.batch_update(Rule.disabled, { timezone: "UTC" }) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


### returns the number of records updated

```ruby
        expect(Rule.batch_update([ rule1.id ], { timezone: "UTC" })).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


### returns 0 if attributes are blank

```ruby
        expect(Rule.batch_update([ rule1.id ], {})).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:66`_


### deletes multiple records by ID

```ruby
        expect { Rule.batch_delete([ rule1.id, rule2.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:72`_


### works with ActiveRecord::Relation

```ruby
        expect { Rule.batch_delete(Rule.disabled) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


### returns the number of records deleted

```ruby
        expect(Rule.batch_delete([ rule1.id ])).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:82`_


### executes a method on multiple records

```ruby
        expect(results[:success]).to eq(2)
        expect(results[:failed]).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:88`_


### handles methods that don

```ruby
        expect(results[:success]).to eq(0)
        expect(results[:failed]).to eq(1)
        expect(results[:errors].first[:error]).to include("nonexistent_method")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:94`_


### handles errors gracefully

```ruby
        expect(results[:failed]).to eq(1)
        expect(results[:errors].first[:error]).to eq("Test error")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:101`_


### assigns multiple assets to a parent

```ruby
        expect { Asset.batch_assign_parent([ asset1.id, asset2.id ], parent.id) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:117`_


### can make assets root by passing nil

```ruby
        expect { Asset.batch_assign_parent([ asset1.id ], nil) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:123`_


### returns the number of records updated

```ruby
        expect(Asset.batch_assign_parent([ asset1.id ], parent.id)).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/concerns/batch_actions.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb`

---

[← Back to Index](/)
