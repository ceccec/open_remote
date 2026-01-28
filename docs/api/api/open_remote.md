# OpenRemote

API documentation for OpenRemote

## Examples

The following examples are extracted from test files:

### is a module

```ruby
    expect(OpenRemote).to be_a(Module)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/open_remote_spec.rb:5`_


### has an Engine

```ruby
    expect(OpenRemote::Engine).to be_a(Class)
    expect(OpenRemote::Engine.superclass).to eq(Rails::Engine)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/open_remote_spec.rb:9`_


### has a Version constant

```ruby
    expect(OpenRemote::VERSION).to be_a(String)
    expect(OpenRemote::VERSION).to match(/\d+\.\d+\.\d+/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/open_remote_spec.rb:14`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/open_remote_spec.rb`

---

[← Back to Index](/)
