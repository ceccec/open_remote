# Mapping::AttributeNormalization

API documentation for Mapping::AttributeNormalization

## Examples

The following examples are extracted from test files:

### extracts values from OpenRemote format

```ruby
      expect(result["totalCapacity"]).to eq(5000)
      expect(result["status"]).to eq("active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:11`_


### handles already normalized attributes

```ruby
      expect(result["totalCapacity"]).to eq(5000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:21`_


### handles empty hash

```ruby
      expect(test_class.normalize_openremote_attributes({})).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:30`_


### handles nil

```ruby
      expect(test_class.normalize_openremote_attributes(nil)).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:34`_


### wraps values in OpenRemote format

```ruby
      expect(result["totalCapacity"]["value"]).to eq(5000)
      expect(result["status"]["value"]).to eq("active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:40`_


### handles empty hash

```ruby
      expect(test_class.denormalize_to_openremote_attributes({})).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:30`_


### handles nil

```ruby
      expect(test_class.denormalize_to_openremote_attributes(nil)).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:34`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb`

---

[← Back to Index](/)
