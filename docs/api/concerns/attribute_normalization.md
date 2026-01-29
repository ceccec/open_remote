# AttributeNormalization

API documentation for AttributeNormalization

This model inherits from `ActiveRecord::Base`, providing database persistence, validations, associations, and callbacks. See [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) for the complete API.

**Rails Framework References:**
- **Base Class**: [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) - `has_many`, `belongs_to`, `has_one` relationships
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks
- **Query Interface**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)


## Examples

The following examples are extracted from test files:

### extracts value from nested hash structure

```ruby
      expect(result["totalCapacity"]).to eq(1000)
      expect(result["totalPowerOutput"]).to eq(800)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:5`_


### preserves non-nested values

```ruby
      expect(result["name"]).to eq("Test Asset")
      expect(result["status"]).to eq("active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:17`_


### handles mixed nested and non-nested values

```ruby
      expect(result["name"]).to eq("Test Asset")
      expect(result["totalCapacity"]).to eq(1000)
      expect(result["status"]).to eq("active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:29`_


### returns empty hash for blank input

```ruby
      expect(Asset.normalize_openremote_attributes(nil)).to eq({})
      expect(Asset.normalize_openremote_attributes({})).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:43`_


### handles hash without value key

```ruby
      expect(result["metadata"]).to eq({ "source" => "sensor", "unit" => "kW" })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:48`_


### wraps values in nested hash structure

```ruby
      expect(result["totalCapacity"]).to eq({ "value" => 1000 })
      expect(result["totalPowerOutput"]).to eq({ "value" => 800 })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:60`_


### handles various value types

```ruby
      expect(result["name"]).to eq({ "value" => "Test Asset" })
      expect(result["capacity"]).to eq({ "value" => 1000 })
      expect(result["active"]).to eq({ "value" => true })
      expect(result["ratio"]).to eq({ "value" => 0.85 })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:72`_


### returns empty hash for blank input

```ruby
      expect(Asset.denormalize_to_openremote_attributes(nil)).to eq({})
      expect(Asset.denormalize_to_openremote_attributes({})).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:43`_


### handles nil values

```ruby
      expect(result["name"]).to eq({ "value" => "Test" })
      expect(result["value"]).to eq({ "value" => nil })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb:93`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/attribute_normalization_spec.rb`

---

[← Back to Index](/)
