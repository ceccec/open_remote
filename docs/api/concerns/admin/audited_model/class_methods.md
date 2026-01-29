---
title: Admin::AuditedModel::ClassMethods
description: Shared concern for RailsAdmin models with audit fields.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Admin::AuditedModel::ClassMethods <Badge type="warning" text="Concern" />

Shared concern for RailsAdmin models with audit fields.
# Provides a helper method to add standard audit field groups.
#
module Admin
  module AuditedModel
    extend ActiveSupport::Concern

::: info File Location
**Source:** `app/models/concerns/admin/audited_model.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="1 instance method" />

::: details View all 1 instance method

- `audit_group` -> `void` - Adds an audit group with created_at and updated_at fields.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
