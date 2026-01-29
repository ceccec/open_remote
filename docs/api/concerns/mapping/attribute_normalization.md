# Mapping::AttributeNormalization

API documentation for Mapping::AttributeNormalization

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns


## Examples

The following examples are extracted from test files:

### extracts values from OpenRemote format

```ruby
      expect(result["totalCapacity"]).to eq(5000)
      expect(result["status"]).to eq("active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:11`_


### handles already normalized attributes

```ruby
      expect(result["totalCapacity"]).to eq(5000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:21`_


### handles empty hash

```ruby
      expect(test_class.normalize_openremote_attributes({})).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:30`_


### handles nil

```ruby
      expect(test_class.normalize_openremote_attributes(nil)).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:34`_


### wraps values in OpenRemote format

```ruby
      expect(result["totalCapacity"]["value"]).to eq(5000)
      expect(result["status"]["value"]).to eq("active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:40`_


### handles empty hash

```ruby
      expect(test_class.denormalize_to_openremote_attributes({})).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:30`_


### handles nil

```ruby
      expect(test_class.denormalize_to_openremote_attributes(nil)).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:34`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb`

---

[← Back to Index](/)
