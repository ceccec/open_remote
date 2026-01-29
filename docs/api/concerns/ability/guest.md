---
title: Ability::Guest
description: Main Ability class for CanCanCan authorization.
lastUpdated: 2026-01-28T21:47:06Z
tags:
  - concern
  - api
  - module
---

# Ability::Guest <Badge type="warning" text="Concern" />

Main Ability class for CanCanCan authorization.
Delegates permission definitions to role-specific modules.

Uses Rolify roles to determine user permissions:
- Admin: Full access to everything
- Manager: Can manage assets/rules/data, read-only for users
- Viewer: Read-only access to assets/rules/data
- Guest: No access (default)

::: info File Location
**Source:** `app/models/ability/guest.rb`
:::

::: tip Rails Framework
:::

## Class Methods

<Badge type="info" text="5 class methods" />

::: details View all 5 class methods

- `define`(ability: CanCan::Ability, user: User) -> `void` - Define permissions for guest users (non-authenticated or non-admin).
- `grant_rails_admin_access`(ability: CanCan::Ability) -> `void` - Grant RailsAdmin access permissions.
- `grant_full_access`(ability: CanCan::Ability) -> `void` - Grant full management permissions for all models.
- `grant_read_access`(ability: CanCan::Ability, models: ArrayClass, Symbol, String) -> `void` - Grant read-only access to specified models.
- `grant_manage_access`(ability: CanCan::Ability, models: ArrayClass, Symbol, String) -> `void` - Grant management access to specified models.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/api/)
