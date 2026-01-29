# Mapping::JsonExport

API documentation for Mapping::JsonExport

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.
**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior


## Examples

The following examples are extracted from test files:

### exports asset to OpenRemote JSON format

```ruby
      expect(json["name"]).to eq("Parent")
      expect(json["type"]).to eq("SolarPark")
      expect(json["attributes"]["powerOutput"]).to eq({ "value" => 100.0 })
      expect(json["children"]).to be_an(Array)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb:22`_


### includes nested children in tree

```ruby
      expect(json["children"].length).to eq(1)
      expect(child_json["name"]).to eq("Child")
      expect(child_json["attributes"]["powerOutput"]).to eq({ "value" => 50.0 })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb:31`_


### denormalizes attributes to OpenRemote format

```ruby
      expect(json["attributes"]["powerOutput"]).to eq({ "value" => 100.0 })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb:43`_


### handles empty attributes_data

```ruby
      expect(json["attributes"]).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb:49`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb`

---

[← Back to Index](/)
