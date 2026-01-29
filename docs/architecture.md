# Architecture Overview

> **Auto-generated** from code structure and feature declarations.
> To regenerate: `rake docs:architecture`

# Architecture Overview

## System Architecture

This application follows a modular architecture where models interact through shared concerns.

### Core Principles

1. **Models declare features** - Each model explicitly declares its capabilities
2. **Concerns enable interactions** - Models interact through shared concerns, not direct dependencies
3. **Test-driven documentation** - Tests serve as executable documentation
4. **Feature-driven development** - Features are declared first, then implemented

## Model Layer

### Core Models

#### ActionText::Record

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### ActiveStorage::Record

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### ActionMailbox::Record

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidCache::Record

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::Record

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidCable::Record

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### HABTM_Roles

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### HABTM_Users

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### PaperTrail::Version

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### ActionText::RichText

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### ActionText::EncryptedRichText

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### ActiveStorage::VariantRecord

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### ActiveStorage::Blob

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### ActiveStorage::Attachment

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### ActionMailbox::InboundEmail

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidCache::Entry

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::Semaphore

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::RecurringTask

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::Process

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::Pause

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::Job

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::Execution

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::ScheduledExecution

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::RecurringExecution

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::ReadyExecution

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::FailedExecution

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::ClaimedExecution

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidQueue::BlockedExecution

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### SolidCable::Message

- Validations: 0
- Associations: 0
- Methods: 0
- Scopes: 0

#### User

- Validations: 2
- Associations: 0
- Methods: 17
- Scopes: 0

#### RuleExecution

- Validations: 2
- Associations: 1
- Methods: 1
- Scopes: 6

#### Rule

- Validations: 1
- Associations: 1
- Methods: 3
- Scopes: 8

#### Role

- Validations: 1
- Associations: 2
- Methods: 2
- Scopes: 0

#### Notification

- Validations: 3
- Associations: 2
- Methods: 1
- Scopes: 9

#### DataPoint

- Validations: 3
- Associations: 1
- Methods: 5
- Scopes: 5

#### AssetType

- Validations: 1
- Associations: 1
- Methods: 1
- Scopes: 2

#### Asset

- Validations: 1
- Associations: 5
- Methods: 3
- Scopes: 6


### Model Features

Models declare their features using the `feature` method:

```ruby
class Asset < ApplicationRecord
  include TestExpectations

  feature :validates, :name, presence: true
  feature :associates, :belongs_to, :asset_type
  feature :provides, :from_openremote_json, :to_openremote_json_tree
  feature :scopes, :solar_arrays, :solar_parks
end
```

## Concern Layer

Concerns provide shared behaviors and enable model interactions:

#### User::Confirmable

- email_confirmation: User

#### Mapping::RuleJsonMapping

- json_import_export: Rule

#### Rule::Execution

- rule_execution: Rule, Asset
- notification_triggering: Rule, Notification
- execution_tracking: Rule, RuleExecution

#### DataPoint::Analytics

- data_analytics: DataPoint, Asset
- time_series_analysis: DataPoint

#### Mapping::JsonExport

- json_export: Asset

#### Mapping::JsonImport

- json_import: Asset

#### Assets::Querying

- querying: Asset
- data_analysis: Asset, DataPoint


### Interaction Patterns

Concerns declare interactions using `enables_interaction`:

```ruby
module Mapping::JsonImport
  extend ConcernFeatures

  enables_interaction :json_import, [:Asset], 
    "Enables Asset to import from OpenRemote JSON format"
end
```

## Data Flow

### Asset Management Flow

1. **Import**: Asset imports from OpenRemote JSON via `Mapping::JsonImport`
2. **Query**: Asset queries data via `Assets::Querying`
3. **Analyze**: DataPoint performs analytics via `DataPoint::Analytics`
4. **Export**: Asset exports to OpenRemote JSON via `Mapping::JsonExport`

### Rule Execution Flow

1. **Schedule**: Rule scheduled via `RuleManager`
2. **Execute**: Rule executes against Asset conditions via `Rule::Execution`
3. **Notify**: Rule triggers Notification creation
4. **Track**: RuleExecution records execution history

## Testing Architecture

### Test Structure

- **Feature Specs** (`spec/features/`) - High-level capabilities and workflows
- **Model Specs** (`spec/models/`) - Unit tests for models
- **Concern Specs** (`spec/models/concerns/`) - Tests for shared behaviors
- **Shared Examples** (`spec/support/shared_examples/`) - Reusable test patterns

### Test Generation

Tests can be generated from feature declarations:

```bash
rake features:generate_tests
```

## Documentation Architecture

All documentation is auto-generated from:

1. **Model feature declarations** - What models can do
2. **Concern interaction declarations** - How models interact
3. **Test examples** - Executable documentation
4. **Code structure** - Architecture patterns

Generate all documentation:

```bash
rake docs:generate_all
```

**Last Updated**: 2026-01-28 21:26:28
