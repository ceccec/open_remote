# Model Interactions via Concerns

> **Auto-generated** from concern interaction declarations.
> To regenerate: `rake docs:interactions`

This document describes how models interact with each other through shared concerns.

**Last Updated**: 2026-01-28 21:26:28

---

## User::Confirmable

This concern enables the following model interactions:

### Email confirmation

- **Models**: `User`
- **Description**: Enables User to confirm email addresses via tokens

---

## Mapping::RuleJsonMapping

This concern enables the following model interactions:

### Json import export

- **Models**: `Rule`
- **Description**: Enables Rule to import/export from OpenRemote JSON format

---

## Rule::Execution

This concern enables the following model interactions:

### Rule execution

- **Models**: `Rule`, `Asset`
- **Description**: Enables Rule to execute against Asset conditions

### Notification triggering

- **Models**: `Rule`, `Notification`
- **Description**: Enables Rule to trigger Notifications

### Execution tracking

- **Models**: `Rule`, `RuleExecution`
- **Description**: Enables Rule to track execution history

---

## DataPoint::Analytics

This concern enables the following model interactions:

### Data analytics

- **Models**: `DataPoint`, `Asset`
- **Description**: Enables DataPoint to perform analytics on Asset data

### Time series analysis

- **Models**: `DataPoint`
- **Description**: Enables time-series aggregation and analysis

---

## Mapping::JsonExport

This concern enables the following model interactions:

### Json export

- **Models**: `Asset`
- **Description**: Enables Asset to export to OpenRemote JSON format, preserving hierarchy

---

## Mapping::JsonImport

This concern enables the following model interactions:

### Json import

- **Models**: `Asset`
- **Description**: Enables Asset to import from OpenRemote JSON format, creating hierarchical structures

---

## Assets::Querying

This concern enables the following model interactions:

### Querying

- **Models**: `Asset`
- **Description**: Enables Asset to query by type, filter by attributes, and interact with AssetType

### Data analysis

- **Models**: `Asset`, `DataPoint`
- **Description**: Enables Asset to query and analyze DataPoint relationships

---

## Model Capabilities

### User

**Interactions enabled by concerns:**

- **Email confirmation**: Enables User to confirm email addresses via tokens

### Rule

**Interactions enabled by concerns:**

- **Json import export**: Enables Rule to import/export from OpenRemote JSON format
- **Rule execution**: Enables Rule to execute against Asset conditions
- **Notification triggering**: Enables Rule to trigger Notifications
- **Execution tracking**: Enables Rule to track execution history

### DataPoint

**Interactions enabled by concerns:**

- **Data analytics**: Enables DataPoint to perform analytics on Asset data
- **Time series analysis**: Enables time-series aggregation and analysis

### Asset

**Interactions enabled by concerns:**

- **Json export**: Enables Asset to export to OpenRemote JSON format, preserving hierarchy
- **Json import**: Enables Asset to import from OpenRemote JSON format, creating hierarchical structures

