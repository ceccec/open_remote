# DocsGenerator

API documentation for DocsGenerator

This model inherits from `ActiveRecord::Base`, providing database persistence, validations, associations, and callbacks. See [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) for the complete API.

**Rails Framework References:**
- **Base Class**: [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) - `has_many`, `belongs_to`, `has_one` relationships
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks
- **Query Interface**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)


## Examples

The following examples are extracted from test files:

### infers controller class name from file path

```ruby
      expect(result).to eq("SomeController")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:8`_


### infers model class name without namespace

```ruby
      expect(result).to eq("User")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:15`_


### infers model class name with namespace when no class definition found

```ruby
      expect(result).to eq("Asset::Querying")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:22`_


### infers service class name

```ruby
      expect(result).to eq("SomeService")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:30`_


### infers job class name

```ruby
      expect(result).to eq("SomeJob")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:37`_


### infers concern class name with namespace when no module definition found

```ruby
      expect(result).to eq("User::Confirmable")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:44`_


### falls back to camelize for unknown types

```ruby
      expect(result).to eq("Unknown")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:52`_


### returns default when file doesn

```ruby
      expect(result).to eq("API documentation for NonExistentClass")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:61`_


### returns default when file has no ## comment

```ruby
        expect(result).to eq("API documentation for TestClass")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:66`_


### truncates methods list when exceeding MAX_METHODS_PER_COMPONENT

```ruby
      expect(doc).to include("truncated to first 50 entries")
      expect(doc.scan(/method_\d+/).length).to eq(50)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:84`_


### formats appearance as false

```ruby
        expect(content).to include("appearance: false")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:102`_


### formats appearance as default true for unknown values

```ruby
        expect(content).to include("appearance: true")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:124`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb`

---

[← Back to Index](/)
