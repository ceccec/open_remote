---
title: TestExpectations
description: Feature declarations for models.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# TestExpectations <Badge type="warning" text="Concern" />

Feature declarations for models.
Models declare their capabilities, which are used to:
- Generate comprehensive tests
- Generate documentation
- Validate feature completeness

::: info File Location
**Source:** `app/models/test_expectations.rb`
:::

::: tip Rails Framework

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **ActiveSupport**: [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport.html) - Utility classes and Ruby extensions

:::

## Examples

<Badge type="tip" text="1 example" />

::: tip 
```ruby
class Notification < ApplicationRecord
  include TestExpectations

  # Declare features
  feature :validates, :message, presence: true
  feature :associates, :belongs_to, :asset, optional: true
  feature :provides, :rails_admin_label
  feature :scopes, :recent, :by_severity
end
```
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
