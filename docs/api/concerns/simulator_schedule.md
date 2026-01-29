---
title: SimulatorSchedule
description: Ruby port of the parts of OpenRemote's SimulatorProtocol.Schedule
lastUpdated: 2026-01-28T21:47:06Z
tags:
  - concern
  - api
---

# SimulatorSchedule <Badge type="warning" text="Concern" />

Ruby port of the parts of OpenRemote's `SimulatorProtocol.Schedule` that are
exercised by the mirrored RSpec tests.

Supports simple RFC5545-style RRULEs with:
- FREQ = DAILY, HOURLY, MINUTELY
- optional COUNT
- optional UNTIL=yyyyMMdd'T'HHmmss
- optional BYHOUR / BYMINUTE for DAILY recurrences.

::: info File Location
**Source:** `app/services/simulator_schedule.rb`
:::

::: tip Rails Framework
:::

## Included Modules

- <Badge type="info" text="Module" /> `JSON::Ext::Generator::GeneratorMethods::Object`

## Class Methods

::: details View all 2 class methods

- `get_delay`(offset_seconds: Integer, time_since_occurrence_start_ms: Integer, schedule: SimulatorSchedule) -> `Integer` - Ruby equivalent of Java's Schedule.getDelay.
- `get_time_until_next_occurrence` - Ruby equivalent of Java's Schedule.getTimeUntilNextOccurrence.
:::

## Instance Methods

::: details View all 12 instance methods

- `start` - Returns the value of attribute start.
- `end_time` - Returns the value of attribute end_time.
- `freq` - Returns the value of attribute freq.
- `by_hour` - Returns the value of attribute by_hour.
- `by_minute` - Returns the value of attribute by_minute.
- `until_time` - Returns the value of attribute until_time.
- `count` - Returns the value of attribute count.
- `current` - Returns the value of attribute current.
- `upcoming` - Returns the value of attribute upcoming.
- `initialize` -> `SimulatorSchedule`
- `try_advance_active`(millis_since_epoch: Integer, tz_offset: Integer) -> `Integer` - Rough equivalent of Java's tryAdvanceActive.
- `is_after_schedule_end`
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/api/)
