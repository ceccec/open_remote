# JsonSchemaUtil

# Lightweight JSON Schema helper inspired by OpenRemote's `JSONSchemaUtil`.

**Type:** Services  
**File:** `json_schema_util.rb`




## Methods

- `build_property_schema`
- `build_schema`


## Examples

The following examples are extracted from test files:

### falls back to string type for unknown Ruby-ish types

```ruby
      expect(schema["type"]).to eq("string")
      expect(schema["title"]).to eq("Unknown")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/json_schema_util_spec.rb:5`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/json_schema_util.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/json_schema_util_spec.rb`

---

[← Back to Index](/)
