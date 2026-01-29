# Assets::SolarArrayAttributes

API documentation for Assets::SolarArrayAttributes

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns


## Examples

The following examples are extracted from test files:

### returns correct values

```ruby
      expect(asset.array_capacity).to eq(5000)
      expect(asset.power_output).to eq(4500)
      expect(asset.panel_count).to eq(20)
      expect(asset.status).to eq("online")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_array_attributes_spec.rb:36`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_array_attributes_spec.rb`

---

[← Back to Index](/)
