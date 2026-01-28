# UniqueIdentifierGenerator Examples

Test-driven examples for UniqueIdentifierGenerator functionality.

### generates deterministic IDs when a name is provided

```ruby
    expect(id1).to eq(id2)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/unique_identifier_generator_spec.rb:4`_


---

### generates non-deterministic IDs when no name is provided

```ruby
    expect(id1).not_to eq(id2)
    expect(id1.length).to be > 0
    expect(id2.length).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/unique_identifier_generator_spec.rb:10`_


---

### returns the first alphabet character when bytes are all zero

```ruby
    expect(id).to eq(described_class::ALPHABET[0])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/unique_identifier_generator_spec.rb:18`_


---

[← Back to Index](/)
