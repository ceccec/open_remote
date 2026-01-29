# JsonSchemaUtil

# Lightweight JSON Schema helper inspired by OpenRemote's `JSONSchemaUtil`.

**Type:** Services  
**File:** `json_schema_util.rb`


::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 1
- **Test file**: `spec/services/json_schema_util_spec.rb`
- **Last tested**: 2026-01-28 18:05:02

:::






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
