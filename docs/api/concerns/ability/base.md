---
title: Ability::Base
description: Base module for ability definitions.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Ability::Base <Badge type="warning" text="Concern" />

Base module for ability definitions.
Provides shared functionality for role-based ability modules.

::: info File Location
**Source:** `app/models/ability/base.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="4 instance methods" />

::: details View all 4 instance methods

- `grant_rails_admin_access`(ability: CanCan::Ability) -> `void` - Grant RailsAdmin access permissions.
- `grant_full_access`(ability: CanCan::Ability) -> `void` - Grant full management permissions for all models.
- `grant_read_access`(ability: CanCan::Ability, models: ArrayClass, Symbol, String) -> `void` - Grant read-only access to specified models.
- `grant_manage_access`(ability: CanCan::Ability, models: ArrayClass, Symbol, String) -> `void` - Grant management access to specified models.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
