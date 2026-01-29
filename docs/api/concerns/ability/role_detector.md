---
title: Ability::RoleDetector
description: Role detection logic for determining user roles.
lastUpdated: 2026-01-28T21:47:06Z
tags:
  - concern
  - api
  - module
---

# Ability::RoleDetector <Badge type="warning" text="Concern" />

Role detection logic for determining user roles.
Uses Rolify roles to determine permissions.

::: info File Location
**Source:** `app/models/ability/role_detector.rb`
:::

::: tip Rails Framework
:::

## Class Methods

<Badge type="info" text="1 class method" />

::: details View all 1 class method

- `role_for`(user: User) -> `Module` - Determine which role module should handle permissions for a user.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/api/)
