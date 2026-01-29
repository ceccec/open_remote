# Ability::Base

# Base module for ability definitions.

**Type:** Models  
**File:** `ability/base.rb`
<Badge type="warning" text="File Coverage: 41.67%" />
<Badge type="info" text="5/48 lines" />


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

:::






## Methods

- `grant_full_access`
  <Badge type="tip" text="Coverage: 100.0%" />
- `grant_manage_access`
  <Badge type="warning" text="Coverage: 33.33%" />
  <small>Uncovered lines: 44, 45</small>
- `grant_rails_admin_access`
  <Badge type="warning" text="Coverage: 50.0%" />
  <small>Uncovered lines: 12</small>
- `grant_read_access`
  <Badge type="warning" text="Coverage: 33.33%" />
  <small>Uncovered lines: 32, 33</small>




## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/ability/base.rb`



---

[← Back to Index](/)
