# DataPoint::Analytics

# Analytics helpers for aggregating `DataPoint` records using Arel.

**Type:** Models  
**File:** `data_point/analytics.rb`
<Badge type="warning" text="File Coverage: 64.71%" />
<Badge type="info" text="22/140 lines" />


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

- `average_for`
  <Badge type="warning" text="Coverage: 29.41%" />
  <small>Uncovered lines: 53, 55, 56, 57, 59...</small>
- `create_continuous_aggregate`
  <Badge type="warning" text="Coverage: 20.0%" />
  <small>Uncovered lines: 131, 132, 133, 134</small>
- `max_for`
  <Badge type="warning" text="Coverage: 29.41%" />
  <small>Uncovered lines: 78, 80, 81, 82, 84...</small>
- `min_for`
  <Badge type="warning" text="Coverage: 5.88%" />
  <small>Uncovered lines: 102, 103, 104, 105, 106...</small>
- `sum_for`
  <Badge type="warning" text="Coverage: 5.88%" />
  <small>Uncovered lines: 27, 28, 29, 30, 31...</small>




## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/data_point/analytics.rb`



---

[← Back to Index](/)
