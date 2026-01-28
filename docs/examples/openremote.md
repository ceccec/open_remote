# OpenRemote Examples

Test-driven examples for OpenRemote functionality.

### is a module

```ruby
    expect(OpenRemote).to be_a(Module)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/open_remote_spec.rb:5`_


---

### has an Engine

```ruby
    expect(OpenRemote::Engine).to be_a(Class)
    expect(OpenRemote::Engine.superclass).to eq(Rails::Engine)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/open_remote_spec.rb:9`_


---

### has a Version constant

```ruby
    expect(OpenRemote::VERSION).to be_a(String)
    expect(OpenRemote::VERSION).to match(/\d+\.\d+\.\d+/)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/open_remote_spec.rb:14`_


---

[← Back to Index](/)
