# OpenRemote Rails

Rails application mirroring OpenRemote Java manager functionality.

> **Note**: This README is auto-generated from model features, interactions, and tests.
> To regenerate: `rake docs:generate_all`


## Features

This application provides comprehensive asset management, rule execution, data analytics, and user management capabilities.

### Core Capabilities

- **Asset Management** - Hierarchical asset structures, type-specific attributes, JSON import/export
- **Rule Engine** - Schedule-based and attribute-based rule execution
- **Data Analytics** - Time-series collection, aggregation functions, analytics
- **Notifications** - Multi-severity alerts and notifications
- **User Management** - Authentication, authorization, role-based access control

### Model Interactions

Models interact with each other through shared concerns:

- **Email confirmation**: User (Enables User to confirm email addresses via tokens)
- **Json import export**: Rule (Enables Rule to import/export from OpenRemote JSON format)
- **Rule execution**: Rule ↔ Asset (Enables Rule to execute against Asset conditions)
- **Notification triggering**: Rule ↔ Notification (Enables Rule to trigger Notifications)
- **Execution tracking**: Rule ↔ RuleExecution (Enables Rule to track execution history)
- **Data analytics**: DataPoint ↔ Asset (Enables DataPoint to perform analytics on Asset data)
- **Time series analysis**: DataPoint (Enables time-series aggregation and analysis)
- **Json export**: Asset (Enables Asset to export to OpenRemote JSON format, preserving hierarchy)
- **Json import**: Asset (Enables Asset to import from OpenRemote JSON format, creating hierarchical structures)
- **Querying**: Asset (Enables Asset to query by type, filter by attributes, and interact with AssetType)

## Quick Start

### Installation

```bash
bundle install
rails db:create db:migrate db:seed
```

### Running the Application

```bash
# Development server
rails server

# RailsAdmin interface (mounted at /api)
# Requires authentication and appropriate role
```

### Testing

```bash
# Run all tests
bundle exec rspec

# Run with coverage
COVERAGE=true bundle exec rspec

# Run CI checks
bin/ci
```

## Architecture

### Models

- **ActionText::Record** - 0 features declared
- **ActiveStorage::Record** - 0 features declared
- **ActionMailbox::Record** - 0 features declared
- **SolidCache::Record** - 0 features declared
- **SolidQueue::Record** - 0 features declared
- **SolidCable::Record** - 0 features declared
- **HABTM_Roles** - 0 features declared
- **HABTM_Users** - 0 features declared
- **PaperTrail::Version** - 0 features declared
- **ActionText::RichText** - 0 features declared
- **ActionText::EncryptedRichText** - 0 features declared
- **ActiveStorage::VariantRecord** - 0 features declared
- **ActiveStorage::Blob** - 0 features declared
- **ActiveStorage::Attachment** - 0 features declared
- **ActionMailbox::InboundEmail** - 0 features declared
- **SolidCache::Entry** - 0 features declared
- **SolidQueue::Semaphore** - 0 features declared
- **SolidQueue::RecurringTask** - 0 features declared
- **SolidQueue::Process** - 0 features declared
- **SolidQueue::Pause** - 0 features declared
- **SolidQueue::Job** - 0 features declared
- **SolidQueue::Execution** - 0 features declared
- **SolidQueue::ScheduledExecution** - 0 features declared
- **SolidQueue::RecurringExecution** - 0 features declared
- **SolidQueue::ReadyExecution** - 0 features declared
- **SolidQueue::FailedExecution** - 0 features declared
- **SolidQueue::ClaimedExecution** - 0 features declared
- **SolidQueue::BlockedExecution** - 0 features declared
- **SolidCable::Message** - 0 features declared
- **User** - 3 features declared
- **RuleExecution** - 5 features declared
- **Rule** - 4 features declared
- **Role** - 4 features declared
- **Notification** - 7 features declared
- **DataPoint** - 6 features declared
- **AssetType** - 4 features declared
- **Asset** - 8 features declared

### Concerns

Concerns enable model interactions and shared behaviors:

- **User::Confirmable** - Enables 1 interaction
- **Mapping::RuleJsonMapping** - Enables 1 interaction
- **Rule::Execution** - Enables 3 interactions
- **DataPoint::Analytics** - Enables 2 interactions
- **Mapping::JsonExport** - Enables 1 interaction
- **Mapping::JsonImport** - Enables 1 interaction
- **Assets::Querying** - Enables 2 interactions

## Documentation

All documentation is compiled in `docs/` and built by VitePress to `public/docs/`.

- **[Model Features](docs/model_features.md)** - Features declared by each model
- **[Model Interactions](docs/model_interactions.md)** - How models interact via concerns
- **[Capabilities](docs/capabilities.md)** - Full application capabilities from tests
- **[Architecture](docs/architecture.md)** - System architecture overview
- **[API Documentation](docs/api/)** - API reference documentation
- **[Rails Guides Code Reviews](docs/reviews/)** - Code reviews comparing implementation against Rails Guides

**Documentation Workflow:**
1. All docs are compiled together in `docs/`
2. VitePress builds from `docs/` to `public/docs/`
3. Documentation is accessible at `/docs/` in production

**Viewing Documentation:**
- **Development**: `npm run docs:dev` (serves from `docs/`)
- **Production**: Built to `public/docs/` (accessible at `/docs/`)
- **GitHub Pages**: Automatically deployed from `docs/`

## Generating Documentation

All documentation is **auto-generated** from model features, interactions, and tests.

```bash
# Generate all documentation (including README)
rake docs:generate_all

# Generate specific docs
rake docs:readme
rake docs:features
rake docs:interactions
rake docs:capabilities
```

> **Note**: Documentation auto-generates after running tests if `GENERATE_DOCS != "false"`

## Authentication

The application implements Devise-like authentication features:

- **Email Confirmation**: Users must confirm their email before logging in
- **Password Reset**: Users can reset passwords via email (6-hour expiration)
- **Remember Me**: Users can stay logged in for 2 weeks
- **Account Locking**: Accounts lock after 5 failed login attempts (2-hour lock)

### Default Admin User (Development/Test Only)

- **Email**: Configurable via `SUPER_ADMIN_EMAIL` environment variable (default: `admin@openremote.local`)
- **Password**: Randomly generated secure password (16 characters)

⚠️ **Security**: Default credentials are only created in development and test environments.

## Role-Based Access Control

Uses Rolify for role management:

- **Admin**: Full access to everything, including user/role management
- **Manager**: Can manage assets, rules, data points, notifications; read-only for users
- **Viewer**: Read-only access to assets, rules, and data
- **Guest**: No access (default for unauthenticated users)

## RailsAdmin

RailsAdmin is mounted at `/api` and serves as the primary API interface.

Access requires:
1. User authentication (login)
2. Admin role or appropriate permissions

## Database Migrations

```bash
# Run migrations
bundle exec rails db:migrate

# Reset database (development/test)
bundle exec rails db:reset
```

## Code Quality

```bash
# Run RuboCop
bundle exec rubocop

# Auto-fix RuboCop offenses
bundle exec rubocop -A

# Run Brakeman security scan
bundle exec brakeman

# Run bundler-audit
bundle exec bundler-audit
```

## License

[Add your license here]

## Contributing

[Add contributing guidelines here]

---

**Last Updated**: 2026-01-28 21:26:28 (Auto-generated)
