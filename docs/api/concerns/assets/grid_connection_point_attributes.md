# Assets::GridConnectionPointAttributes

API documentation for Assets::GridConnectionPointAttributes

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns


## Examples

The following examples are extracted from test files:

### returns correct values

```ruby
      expect(asset.connection_capacity).to eq(10_000)
      expect(asset.active_power).to eq(8000)
      expect(asset.energy_exported).to eq(50_000)
      expect(asset.connection_status).to eq("connected")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/grid_connection_point_attributes_spec.rb:35`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/grid_connection_point_attributes_spec.rb`

---

[← Back to Index](/)
