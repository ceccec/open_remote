# Assets::Querying

API documentation for Assets::Querying

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.
**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior


## Examples

The following examples are extracted from test files:

### returns only solar arrays

```ruby
      expect(arrays).to include(@array)
      expect(arrays).not_to include(@park)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:21`_


### returns only solar parks

```ruby
      expect(parks).to include(@park)
      expect(parks).not_to include(@array)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:29`_


### returns assets of specific type

```ruby
      expect(parks).to include(@park)
      expect(parks).not_to include(@array)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:37`_


### returns id and power output pairs for solar arrays

```ruby
      expect(pairs.size).to eq(2)
      expect(pairs.map(&:first)).to contain_exactly(@array.id.to_s, array2.id.to_s)
      expect(pairs.map(&:last)).to contain_exactly(1000.0, 2000.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:45`_


### returns empty array when no solar arrays exist

```ruby
      expect(pairs).to be_empty
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:59`_


### handles arrays without powerOutput attribute

```ruby
      expect(pair).to be_present
      expect(pair.last).to eq(0.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:66`_


### handles arrays with nil attributes_data

```ruby
      expect(pair).to be_present
      expect(pair.last).to eq(0.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:80`_


### handles string numeric powerOutput values

```ruby
      expect(pairs.map(&:last)).to include(1500.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:95`_


### ensures id is always a string

```ruby
        expect(id_str).to be_a(String)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:106`_


### filters assets by numeric attribute value

```ruby
      expect(result).to include(high_capacity)
      expect(result).not_to include(low_capacity)
      expect(result).not_to include(@park)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:115`_


### handles string numeric values

```ruby
      expect(result).to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:134`_


### excludes assets without the attribute

```ruby
      expect(result).not_to include(asset_no_attr)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:145`_


### handles different attribute names

```ruby
      expect(result).to include(asset)
      expect(result).not_to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:156`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb`

---

[← Back to Index](/)
