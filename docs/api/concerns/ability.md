---
title: Ability
description: Main Ability class for CanCanCan authorization., Reusable concern module, includes CanCan::Ability, CanCan::Ability::StrongParameterSupport, CanCan::Unauthori...
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
head:
  - - meta
    - name: keywords
      content: Ability, concern, rails, api, ruby, module, reusable, CanCan::Ability, CanCan::Ability::StrongParameterSupport, CanCan::UnauthorizedMessageResolver, CanCan::Ability::Actions, CanCan::Ability::Rules, JSON::Ext::Generator::GeneratorMethods::Object, initialize
  - - meta
    - property: og:title
      content: Ability - OpenRemote Rails API
  - - meta
    - property: og:description
      content: Main Ability class for CanCanCan authorization., Reusable concern module, includes CanCan::Ability, CanCan::Ability::StrongParameterSupport, CanCan::Unauthori...
  - - meta
    - property: og:type
      content: website
---

# Ability <Badge type="warning" text="Concern" />

Main Ability class for CanCanCan authorization.
Delegates permission definitions to role-specific modules.

Uses Rolify roles to determine user permissions:
- Admin: Full access to everything
- Manager: Can manage assets/rules/data, read-only for users
- Viewer: Read-only access to assets/rules/data
- Guest: No access (default)

::: info File Location
**Source:** `app/models/ability/admin.rb`
:::

::: tip Rails Framework
:::

## Included Modules

- <Badge type="info" text="Module" /> `CanCan::Ability`
- <Badge type="info" text="Module" /> `CanCan::Ability::StrongParameterSupport`
- <Badge type="info" text="Module" /> `CanCan::UnauthorizedMessageResolver`
- <Badge type="info" text="Module" /> `CanCan::Ability::Actions`
- <Badge type="info" text="Module" /> `CanCan::Ability::Rules`
- <Badge type="info" text="Module" /> `JSON::Ext::Generator::GeneratorMethods::Object`

## Instance Methods

::: details View all 1 instance method

- `initialize`(user: User) -> `Ability` - Initialize abilities for a user based on their role.
:::

## Examples

<Badge type="tip" text="2 examples" />

::: tip Create ability for admin user
```ruby
user = User.find_by(email: "admin@example.com")
ability = Ability.new(user)
ability.can?(:manage, :all) # => true
```
:::

::: tip Create ability for manager user
```ruby
user = User.find_by(email: "manager@example.com")
user.add_role(:manager)
ability = Ability.new(user)
ability.can?(:manage, Asset) # => true
ability.can?(:manage, User) # => false
```
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
