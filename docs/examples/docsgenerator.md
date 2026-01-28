# DocsGenerator Examples

Test-driven examples for DocsGenerator functionality.

### infers controller class name from file path

```ruby
      expect(result).to eq("SomeController")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:8`_


---

### infers model class name without namespace

```ruby
      expect(result).to eq("User")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:15`_


---

### infers model class name with namespace

```ruby
      expect(result).to eq("Asset::Querying")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:22`_


---

### infers service class name

```ruby
      expect(result).to eq("SomeService")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:30`_


---

### infers job class name

```ruby
      expect(result).to eq("SomeJob")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:37`_


---

### infers concern class name with namespace

```ruby
      expect(result).to eq("User::Confirmable")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:44`_


---

### falls back to camelize for unknown types

```ruby
      expect(result).to eq("Unknown")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:52`_


---

### returns default when file doesn

```ruby
      expect(result).to eq("API documentation for NonExistentClass")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:61`_


---

### returns default when file has no ## comment

```ruby
        expect(result).to eq("API documentation for TestClass")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:66`_


---

### truncates methods list when exceeding MAX_METHODS_PER_COMPONENT

```ruby
      expect(doc).to include("truncated to first 50 entries")
      expect(doc.scan(/method_\d+/).length).to eq(50)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:84`_


---

### formats appearance as false

```ruby
        expect(content).to include("appearance: false")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:102`_


---

### formats appearance as default true for unknown values

```ruby
        expect(content).to include("appearance: true")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/lib/tasks/docs_generator_spec.rb:124`_


---

[← Back to Index](/)
