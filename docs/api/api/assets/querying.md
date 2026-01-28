# Assets::Querying

API documentation for Assets::Querying

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
      expect(pairs.map(&:first)).to contain_exactly(@array.id, array2.id)
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
      expect(pairs.size).to be >= 1
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:66`_


### handles string numeric powerOutput values

```ruby
      expect(pairs.map(&:last)).to include(1500.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:78`_


### filters assets by numeric attribute value

```ruby
      expect(result).to include(high_capacity)
      expect(result).not_to include(low_capacity)
      expect(result).not_to include(@park)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:91`_


### handles string numeric values

```ruby
      expect(result).to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:110`_


### excludes assets without the attribute

```ruby
      expect(result).not_to include(asset_no_attr)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:121`_


### handles different attribute names

```ruby
      expect(result).to include(asset)
      expect(result).not_to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:132`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb`

---

[← Back to Index](/)
