# Assets::WeatherStationAttributes

API documentation for Assets::WeatherStationAttributes

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns


## Examples

The following examples are extracted from test files:

### returns correct values

```ruby
      expect(asset.temperature).to eq(25.5)
      expect(asset.humidity).to eq(60)
      expect(asset.solar_irradiance).to eq(800)
      expect(asset.location).to eq("40.7128,-74.0060")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/weather_station_attributes_spec.rb:35`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/weather_station_attributes_spec.rb`

---

[← Back to Index](/)
