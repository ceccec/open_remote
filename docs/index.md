# OpenRemote Rails API Documentation

Comprehensive API documentation auto-generated from Rails components and test examples.

## Quick Start

```bash
# Generate documentation from components and tests
bundle exec rake docs:from_tests

# View documentation
npm run docs:dev
```

## Components

### Models (15)

- [Ability](/api/models/ability)
- [Ability::Base](/api/models/ability/base)
- [Ability::RoleDetector](/api/models/ability/role_detector)
- [Asset](/api/models/asset)
- [AssetType](/api/models/asset_type)
- [DataPoint](/api/models/data_point)
- [DataPoint::Analytics](/api/models/data_point/analytics)
- [Notification](/api/models/notification)
- [Role](/api/models/role)
- [Rule](/api/models/rule)
- [Rule::Execution](/api/models/rule/execution)
- [RuleExecution](/api/models/rule_execution)
- [UniqueIdentifierGenerator](/api/models/unique_identifier_generator)
- [User](/api/models/user)
- [ValueUtil](/api/models/value_util)

### Controllers (6)

- [ConfirmationsController](/api/controllers/confirmations_controller)
- [DocsController](/api/controllers/docs_controller)
- [PasswordsController](/api/controllers/passwords_controller)
- [RegistrationsController](/api/controllers/registrations_controller)
- [SessionsController](/api/controllers/sessions_controller)
- [UnlocksController](/api/controllers/unlocks_controller)

### Services (7)

- [AssetDatapointService](/api/services/asset_datapoint_service)
- [AssetProcessingService](/api/services/asset_processing_service)
- [JsonSchemaUtil](/api/services/json_schema_util)
- [LockByKey](/api/services/lock_by_key)
- [PseudoClock](/api/services/pseudo_clock)
- [RuleManager](/api/services/rule_manager)
- [SimulatorSchedule](/api/services/simulator_schedule)

### Jobs (4)

- [ApplicationJob](/api/jobs/application_job)
- [DatapointCleanupJob](/api/jobs/datapoint_cleanup_job)
- [RuleExecutionJob](/api/jobs/rule_execution_job)
- [RuleManagerJob](/api/jobs/rule_manager_job)

### Concerns (7)

- [Admin](/api/concerns/admin)
- [Assets](/api/concerns/assets)
- [Mapping](/api/concerns/mapping)
- [User::Confirmable](/api/concerns/user/confirmable)
- [User::Lockable](/api/concerns/user/lockable)
- [User::Recoverable](/api/concerns/user/recoverable)
- [User::Rememberable](/api/concerns/user/rememberable)


## Examples

All examples are extracted from RSpec test files and demonstrate real usage.

See [Examples](/examples/) for detailed test-driven examples.
