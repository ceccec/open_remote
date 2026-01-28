---
name: learn-from-openremote-rails-architecture
overview: Study the `openremote_rails` app and produce an architecture-focused gap analysis against the current `open_remote` app so we can later transfer patterns intentionally.
todos: []
isProject: false
---

## Goal

Provide an **architecture-focused gap analysis** between this app (`open_remote`) and the reference app (`openremote_rails`), highlighting reusable patterns you might want to adopt later.

## High-level architecture comparison

- **Rails & core stack**
  - Both apps use **Rails 8.1.2**, **PostgreSQL**, **propshaft**, **importmap-rails**, **turbo-rails**, **stimulus-rails**, **jbuilder**, **solid_cache/solid_queue/solid_cable**, **bootsnap**, **kamal**, **thruster**, and **image_processing** (see `Gemfile` in both repos).
  - Both apps use **vite_rails** and **rails_admin** (see `Gemfile` in this app and `[../openremote_rails/Gemfile](../openremote_rails/Gemfile)`).
- **App module & configuration**
  - Both apps have nearly identical `config/application.rb` (same `config.load_defaults 8.1` and `config.autoload_lib(ignore: %w[assets tasks])`).
  - Namespaces differ: `OpenRemote` here vs `OpenremoteRails` in `[../openremote_rails/config/application.rb](../openremote_rails/config/application.rb)`.
- **Routing & entrypoints**
  - **This app** (`config/routes.rb`):
    - Mounts `RailsAdmin::Engine` at `/api` and exposes a health check at `/up`.
    - No root route or user-facing pages are defined yet.
  - **Reference app** (`[../openremote_rails/config/routes.rb](../openremote_rails/config/routes.rb)`):
    - Defines explicit **auth routes**: `/login` (new/create) and `/logout` (destroy) via `SessionsController`.
    - Mounts `RailsAdmin::Engine` at `/` (root), with a `root to: redirect('/')` to the admin.
    - Also exposes `/up` health check.
  - **Gap**: This app lacks **authentication routes**, a **root path**, and the opinionated choice of **admin at root**.

## Domain modeling & concerns architecture

- **Reference app domain models** (`[../openremote_rails/app/models](../openremote_rails/app/models)`):
  - Core models: `AssetType`, `Asset`, `DataPoint`, `Rule`, `RuleExecution`, `Notification`, `User`.
  - These models are **thin** and delegate most domain logic into namespaced concerns:
    - `Assets` concerns: `[../openremote_rails/app/models/concerns/assets](../openremote_rails/app/models/concerns/assets)` (e.g., `type_dispatch`, `querying`, per-asset-type attributes).
    - `DataPoints` concerns: analytics logic in `[../openremote_rails/app/models/concerns/data_points/analytics.rb](../openremote_rails/app/models/concerns/data_points/analytics.rb)`.
    - `Mapping` concerns: import/export/normalization in `[../openremote_rails/app/models/concerns/mapping](../openremote_rails/app/models/concerns/mapping)`.
    - `Rules` concerns: execution and JSON mapping in `[../openremote_rails/app/models/concerns/rules](../openremote_rails/app/models/concerns/rules)`.
  - Example: `Asset` includes `Assets::TypeDispatch`, `Assets::Querying`, and several `Mapping::*` concerns; `Rule` includes `Rules::Execution` and `Mapping::RuleJsonMapping`; `DataPoint` includes `DataPoints::Analytics`.
- **This app’s domain layer** (`app/models` here):
  - Only `application_record.rb` exists plus an empty `app/models/concerns` directory.
  - There are **no domain models** yet for assets, rules, data points, or users.
- **Gap**:
  - This app is currently a **skeleton** with no domain modeling.
  - The reference app provides a **full domain model** (assets, rules, time-series data, users) with a clear **concerns-based layering** you can reuse as-is or adapt.

## Authentication & authorization

- **Reference app**:
  - Uses **Rails native authentication** via `has_secure_password` in `[../openremote_rails/app/models/user.rb](../openremote_rails/app/models/user.rb)`.
  - `bcrypt` is enabled in its `Gemfile` and a `User` model with email/password validations is present.
  - Implements a `SessionsController` (`[../openremote_rails/app/controllers/sessions_controller.rb](../openremote_rails/app/controllers/sessions_controller.rb)`) and login form view (`[../openremote_rails/app/views/sessions/new.html.erb](../openremote_rails/app/views/sessions/new.html.erb)`), wired up in `routes.rb`.
- **This app**:
  - `bcrypt` is **commented out** in `Gemfile`.
  - No `User` model, no `SessionsController`, and no auth-related routes or views.
- **Gap**:
  - Missing **end-to-end authentication flow** (model, session controller, routes, view, and integration with `rails_admin`).
  - No foundation yet for **role-based access** or per-user permissions for admin features.

## Background jobs, queues, and domain workflows

- **Reference app**:
  - Defines `RuleExecutionJob` (`[../openremote_rails/app/jobs/rule_execution_job.rb](../openremote_rails/app/jobs/rule_execution_job.rb)`) that loads a `Rule`, checks `enabled?`, and calls `execute!`, with logging on failure.
  - This job architecture ties into `solid_queue` and gives a pattern for **domain-level background workflows**.
- **This app**:
  - Has only `ApplicationJob` and no concrete jobs.
- **Gap**:
  - No **example or pattern** for domain-specific jobs or queue usage, even though the gems are present.
  - You can lift the **job pattern** (simple job calling rich domain methods) directly from the reference app when you introduce background workflows.

## Time-series and TimescaleDB usage

- **Reference app**:
  - README documents optional **TimescaleDB** integration and `timescaledb:create_aggregates` / `refresh_aggregates` rake tasks.
  - `DataPoint` plus `DataPoints::Analytics` concern provide an opinionated **time-series domain model**.
- **This app**:
  - No README guidance, models, or tasks around time-series data.
- **Gap**:
  - No **time-series abstraction** yet; you can reuse the `DataPoint` model + analytics concern + TimescaleDB tasks if/when you need time-series analytics.

## Admin interface (rails_admin) usage

- **Reference app**:
  - `rails_admin` is mounted at `/` and effectively **is the primary UI**.
  - Domain models are designed to be **admin-manageable** out of the box (validations, associations, simple concerns APIs).
- **This app**:
  - `rails_admin` is mounted at `/api`, which hints that it might eventually be treated as a **secondary / admin-only** interface.
  - No domain models yet to expose in the admin.
- **Gap**:
  - Strategic decision point: whether to **mirror `openremote_rails` and let `rails_admin` be the UI**, or keep it as a **secondary admin backend** with a separate user-facing UI.

## Frontend & Vite integration

- **Both apps**:
  - Use `vite_rails` and have `vite.config.ts` plus `app/javascript/entrypoints/application.js`.
- **Reference app**:
  - README (`[../openremote_rails/README.md](../openremote_rails/README.md)`) clearly documents the Vite dev server flow (`bin/vite dev`) alongside `rails s`.
  - RailsAdmin’s own Sprockets pipeline coexists with Vite for any custom frontend.
- **This app**:
  - Has the same basic Vite setup but **no documented flow** or opinionated structure for custom frontend beyond the Rails defaults.
- **Gap**:
  - Missing **documentation and conventions** for using Vite and where custom frontends should live, but the technical wiring is mostly identical.

## Testing & quality tooling

- **Reference app**:
  - Uses **RSpec** (`rspec-rails` in `Gemfile`, `spec/` directory, plus `TESTING.md` and `QUICK_REFERENCE.md`).
  - Lean test folder under `test/` but main tests appear to live in `spec/`.
- **This app**:
  - Uses the default **Minitest** structure (`test/` directory, `test_helper.rb`) and no `spec/` directory.
- **Both apps**:
  - Share security and quality tools: `bundler-audit`, `brakeman`, `rubocop-rails-omakase`.
- **Gap**:
  - Different **testing philosophy** (RSpec vs Minitest) and missing **test docs** and examples here.

## Documentation & operational runbooks

- **Reference app**:
  - Has a detailed `[../openremote_rails/README.md](../openremote_rails/README.md)`, `TESTING.md`, and `QUICK_REFERENCE.md` explaining setup, testing, and key workflows.
- **This app**:
  - README is the untouched Rails template with no project-specific documentation.
- **Gap**:
  - Missing **project-level documentation**: setup, workflows, import processes, and testing conventions.

## Conceptual architecture diagram (reference app)

```mermaid
flowchart TD
  client["Browser"] --> railsAdmin["RailsAdmin UI (/)"]
  railsAdmin --> controllers["Rails Controllers"]
  controllers --> models["Domain Models (Asset, Rule, DataPoint, User)"]
  models --> concerns[
```



