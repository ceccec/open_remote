# OpenRemote

API documentation for OpenRemote

This model inherits from `ActiveRecord::Base`, providing database persistence, validations, associations, and callbacks. See [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) for the complete API.

**Rails Framework References:**
- **Base Class**: [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) - `has_many`, `belongs_to`, `has_one` relationships
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks
- **Query Interface**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)


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
