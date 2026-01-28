# Mapping::RuleJsonMapping

API documentation for Mapping::RuleJsonMapping

## Examples

The following examples are extracted from test files:

### creates rule from OpenRemote JSON node

```ruby
      expect(rule).to be_persisted
      expect(rule.name).to eq("Test Rule")
      expect(rule.description).to eq("Test Description")
      expect(rule.enabled).to be(true)
      expect(rule.when_config).to eq({ "schedule" => "FREQ=DAILY" })
      expect(rule.then_config).to eq([ { "action" => "log" } ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:5`_


### extracts schedule and timezone from when config

```ruby
      expect(rule.schedule).to eq("FREQ=HOURLY")
      expect(rule.timezone).to eq("America/New_York")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:24`_


### defaults enabled to true if not provided

```ruby
      expect(rule.enabled).to be(true)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:40`_


### defaults timezone to UTC if not provided

```ruby
      expect(rule.timezone).to eq("UTC")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:52`_


### updates existing rule if name matches

```ruby
      expect do
      expect(existing.when_config).to eq({ "new" => "data" })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:64`_


### exports rule to OpenRemote JSON format

```ruby
      expect(json["name"]).to eq("Test Rule")
      expect(json["description"]).to eq("Test Description")
      expect(json["enabled"]).to be(true)
      expect(json["when"]).to eq({ "schedule" => "FREQ=DAILY" })
      expect(json["then"]).to eq([ { "action" => "log" } ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:97`_


### handles nil description

```ruby
      expect(json["description"]).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:107`_


### defaults empty configs to empty objects/arrays

```ruby
      expect(json["when"]).to eq({})
      expect(json["then"]).to eq([])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:114`_


## Methods

### `to_openremote_json`




## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb`

---

[← Back to Index](/)
