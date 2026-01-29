---
title: RuleManager
description: Service for managing rule scheduling and periodic execution., Reusable concern module, includes JSON::Ext::Generator::GeneratorMethods::Object
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
head:
  - - meta
    - name: keywords
      content: RuleManager, concern, rails, api, ruby, module, reusable, JSON::Ext::Generator::GeneratorMethods::Object, execute_due_rules, find_due_rules, rule_due?, next_execution_time, enqueue_rule_execution, parse_schedule, cron_pattern?, time_pattern?, interval_pattern?, parse_cron_schedule
  - - meta
    - property: og:title
      content: RuleManager - OpenRemote Rails API
  - - meta
    - property: og:description
      content: Service for managing rule scheduling and periodic execution., Reusable concern module, includes JSON::Ext::Generator::GeneratorMethods::Object
  - - meta
    - property: og:type
      content: website
---

# RuleManager <Badge type="warning" text="Concern" />

Service for managing rule scheduling and periodic execution.

This service handles:
- Finding rules that are due for execution based on their schedule
- Enqueueing rule execution jobs
- Managing rule execution lifecycle

::: info File Location
**Source:** `app/services/rule_manager.rb`
:::

::: tip Rails Framework
:::

## Included Modules

- <Badge type="info" text="Module" /> `JSON::Ext::Generator::GeneratorMethods::Object`

## Class Methods

::: details View all 17 class methods

- `execute_due_rules` -> `Integer` - Execute all rules that are due based on their schedule.
- `find_due_rules` -> `Array<Rule>` - Find all enabled rules that are due for execution.
- `rule_due?`(rule: Rule) -> `Boolean` - Check if a rule is due for execution based on its schedule.
- `next_execution_time`(rule: Rule) -> `Time` - Calculate the next execution time for a rule based on its schedule.
- `enqueue_rule_execution`(rule: Rule) -> `void` - Enqueue a rule for execution via the job queue.
- `parse_schedule`(schedule: String, base_time: Time, timezone: ActiveSupport::TimeZone) -> `Time` - Parse a schedule string and return the next execution time.
- `cron_pattern?`(schedule: String) -> `Boolean` - Check if schedule matches cron pattern.
- `time_pattern?`(schedule: String) -> `Boolean` - Check if schedule matches time pattern (HH:MM).
- `interval_pattern?`(schedule: String) -> `Boolean` - Check if schedule matches interval pattern.
- `parse_cron_schedule`(schedule: String, base_time: Time, timezone: ActiveSupport::TimeZone) -> `Time` - Parse a cron-like schedule expression.
- `parse_time_schedule`(schedule: String, base_time: Time, timezone: ActiveSupport::TimeZone) -> `Time` - Parse a time schedule (HH:MM format).
- `parse_interval_schedule`(schedule: String, base_time: Time, timezone: ActiveSupport::TimeZone) -> `Time` - Parse an interval schedule (e.g., "every 5 minutes").
- `parse_specific_time`(minute: String, hour: String, day: String, month: String, weekday: String, base_time: Time, timezone: ActiveSupport::TimeZone) -> `Time` - Parse a specific cron time pattern.
- `matches_schedule?`(schedule: String, time: Time, timezone: ActiveSupport::TimeZone) -> `Boolean` - Check if a given time matches the schedule pattern.
- `matches_cron_schedule`(schedule: String, time: Time, timezone: ActiveSupport::TimeZone) -> `Boolean` - Check if time matches a cron schedule.
- `matches_field`(field: String, value: Integer) -> `Boolean` - Check if a value matches a cron field pattern.
- `matches_time_schedule`(schedule: String, time: Time, timezone: ActiveSupport::TimeZone) -> `Boolean` - Check if time matches a time schedule (HH:MM).
:::

::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />

- **Total Test Files**: 69

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
