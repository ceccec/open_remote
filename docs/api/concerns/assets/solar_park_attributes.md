# Assets::SolarParkAttributes

API documentation for Assets::SolarParkAttributes

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns


## Examples

The following examples are extracted from test files:

### does nothing when total_capacity is zero

```ruby
      expect { asset.update_performance_ratio! }.not_to change { asset.attributes_data["performanceRatio"] }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:14`_


### does nothing when total_capacity is negative

```ruby
      expect { asset.update_performance_ratio! }.not_to change { asset.attributes_data["performanceRatio"] }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:19`_


### calculates and saves performance ratio when capacity is positive

```ruby
      expect(asset.attributes_data["performanceRatio"]).to eq(0.8)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:24`_


### initializes attributes_data if nil

```ruby
      expect(asset.attributes_data["performanceRatio"]).to eq(0.5)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:31`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb`

---

[← Back to Index](/)
