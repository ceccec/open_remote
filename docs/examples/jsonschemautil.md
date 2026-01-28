# JsonSchemaUtil Examples

Test-driven examples for JsonSchemaUtil functionality.

### falls back to string type for unknown Ruby-ish types

```ruby
      expect(schema["type"]).to eq("string")
      expect(schema["title"]).to eq("Unknown")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/json_schema_util_spec.rb:5`_


---

[← Back to Index](/)
