# UniqueIdentifierGenerator

API documentation for UniqueIdentifierGenerator

**Type:** Models  
**File:** `unique_identifier_generator.rb`
<Badge type="warning" text="File Coverage: 36.84%" />
<Badge type="info" text="7/36 lines" />


This model inherits from `ActiveRecord::Base`, providing database persistence, validations, associations, and callbacks. See [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) for the complete API.

**Rails Framework References:**
- **Base Class**: [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) - `has_many`, `belongs_to`, `has_one` relationships
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks
- **Query Interface**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)


::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 3
- **Test file**: `spec/models/unique_identifier_generator_spec.rb`
- **Last tested**: 2026-01-28 18:05:02

:::






## Methods

- `base62_encode`
  <Badge type="warning" text="Coverage: 9.09%" />
  <small>Uncovered lines: 23, 24, 25, 26, 27...</small>
- `generate_id`
  <Badge type="warning" text="Coverage: 12.5%" />
  <small>Uncovered lines: 10, 11, 12, 13, 14...</small>


## Examples

The following examples are extracted from test files:

### generates deterministic IDs when a name is provided

```ruby
    expect(id1).to eq(id2)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/unique_identifier_generator_spec.rb:4`_


### generates non-deterministic IDs when no name is provided

```ruby
    expect(id1).not_to eq(id2)
    expect(id1.length).to be > 0
    expect(id2.length).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/unique_identifier_generator_spec.rb:10`_


### returns the first alphabet character when bytes are all zero

```ruby
    expect(id).to eq(described_class::ALPHABET[0])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/unique_identifier_generator_spec.rb:18`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/unique_identifier_generator.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/unique_identifier_generator_spec.rb`

---

[← Back to Index](/)
