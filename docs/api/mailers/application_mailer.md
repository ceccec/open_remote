---
title: ApplicationMailer
description: Base mailer for all application emails., Email mailer, includes ActionDispatch::Routing::RouteSet::MountedHelpers, AbstractController::UrlFor, ActionDispatch:...
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - mailer
  - api
head:
  - - meta
    - name: keywords
      content: ApplicationMailer, mailer, rails, api, ruby, actionmailer, email, ActionDispatch::Routing::RouteSet::MountedHelpers, AbstractController::UrlFor, ActionDispatch::Routing::UrlFor, ActionDispatch::Routing::PolymorphicRoutes, AbstractController::Caching, AbstractController::Caching::ConfigMethods, AbstractController::Caching::Fragments, AbstractController::Callbacks, AbstractController::AssetPaths, AbstractController::Translation, AbstractController::Helpers, AbstractController::Logger, AbstractController::Rendering, ActionMailer::FormBuilder, ActionMailer::Previews, ActionMailer::Parameterized, ActionMailer::Rescuable, ActionMailer::QueuedDelivery, ActionMailer::DeliveryMethods, ActionMailer::Callbacks, JSON::Ext::Generator::GeneratorMethods::Object
  - - meta
    - property: og:title
      content: ApplicationMailer - OpenRemote Rails API
  - - meta
    - property: og:description
      content: Base mailer for all application emails., Email mailer, includes ActionDispatch::Routing::RouteSet::MountedHelpers, AbstractController::UrlFor, ActionDispatch:...
  - - meta
    - property: og:type
      content: website
---

# ApplicationMailer <Badge type="warning" text="Mailer" />

Base mailer for all application emails.

Provides default configuration for all mailers, including:
- Default sender address
- Mailer layout template

::: info File Location
**Source:** `app/mailers/application_mailer.rb`
:::

::: tip Rails Framework

This mailer inherits from `ActionMailer::Base`, providing email composition. See [ActionMailer::Base](https://api.rubyonrails.org/classes/ActionMailer/Base.html) for the complete API.

**Rails Framework References:**
- **Base Class**: [ActionMailer::Base](https://api.rubyonrails.org/classes/ActionMailer/Base.html)

:::

## Included Modules

- <Badge type="info" text="Module" /> `ActionDispatch::Routing::RouteSet::MountedHelpers`
- <Badge type="info" text="Module" /> `AbstractController::UrlFor`
- <Badge type="info" text="Module" /> `ActionDispatch::Routing::UrlFor`
- <Badge type="info" text="Module" /> `ActionDispatch::Routing::PolymorphicRoutes`
- <Badge type="info" text="Module" /> `AbstractController::Caching`
- <Badge type="info" text="Module" /> `AbstractController::Caching::ConfigMethods`
- <Badge type="info" text="Module" /> `AbstractController::Caching::Fragments`
- <Badge type="info" text="Module" /> `AbstractController::Callbacks`
- <Badge type="info" text="Module" /> `AbstractController::AssetPaths`
- <Badge type="info" text="Module" /> `AbstractController::Translation`
- <Badge type="info" text="Module" /> `AbstractController::Helpers`
- <Badge type="info" text="Module" /> `AbstractController::Logger`
- <Badge type="info" text="Module" /> `AbstractController::Rendering`
- <Badge type="info" text="Module" /> `ActionMailer::FormBuilder`
- <Badge type="info" text="Module" /> `ActionMailer::Previews`
- <Badge type="info" text="Module" /> `ActionMailer::Parameterized`
- <Badge type="info" text="Module" /> `ActionMailer::Rescuable`
- <Badge type="info" text="Module" /> `ActionMailer::QueuedDelivery`
- <Badge type="info" text="Module" /> `ActionMailer::DeliveryMethods`
- <Badge type="info" text="Module" /> `ActionMailer::Callbacks`
- <Badge type="info" text="Module" /> `JSON::Ext::Generator::GeneratorMethods::Object`

## Examples

<Badge type="tip" text="1 example" />

::: tip Creating a new mailer
```ruby
class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: user.email, subject: "Welcome!")
  end
end
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
