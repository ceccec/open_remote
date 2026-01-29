# Assets::EnergyMeterAttributes

API documentation for Assets::EnergyMeterAttributes

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns


## Examples

The following examples are extracted from test files:

### returns correct values from attributes_data

```ruby
      expect(asset.active_power).to eq(1000)
      expect(asset.reactive_power).to eq(500)
      expect(asset.apparent_power).to eq(1118)
      expect(asset.energy_import).to eq(5000)
      expect(asset.energy_export).to eq(2000)
      expect(asset.voltage).to eq(240)
      expect(asset.current).to eq(4.17)
      expect(asset.power_factor).to eq(0.9)
      expect(asset.frequency).to eq(60)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/energy_meter_attributes_spec.rb:39`_


### returns nil when attributes_data is empty

```ruby
      expect(asset.active_power).to be_nil
      expect(asset.voltage).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/energy_meter_attributes_spec.rb:51`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/energy_meter_attributes_spec.rb`

---

[← Back to Index](/)
