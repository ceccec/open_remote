# Application Capabilities

This document describes the full potential of the OpenRemote Rails application,
extracted from comprehensive test coverage. Each capability is demonstrated
through real test scenarios.

**Last Updated**: 2026-01-28 21:26:28
**Test Coverage**: 4 feature spec files

---

## Asset Management

The application provides comprehensive asset management capabilities:

### Asset management

Asset Management

**Key Capabilities:**

- supports multi-level asset hierarchies with parent-child relationships
- supports cascading deletion of child assets
- dynamically extends assets with type-specific methods
- supports multiple asset types with different attributes
- imports complete asset hierarchies from OpenRemote JSON format

### Integration workflows

End-to-End Integration Workflows

**Key Capabilities:**

- demonstrates full lifecycle: import, monitor, analyze, alert
- manages diverse asset portfolio with different capabilities
- demonstrates complete user lifecycle with role-based access
- executes rules and generates notifications for stakeholders
- uses historical data to inform operational decisions

### Rule engine

Rule Engine

**Key Capabilities:**

- executes rules based on cron schedules
- supports interval-based schedules
- supports time-of-day schedules
- triggers rules when asset attribute values match conditions
- triggers rules when asset attributes change


---

## Data Analytics

The application provides comprehensive data analytics capabilities:

### Asset management

Asset Management

**Key Capabilities:**

- supports multi-level asset hierarchies with parent-child relationships
- supports cascading deletion of child assets
- dynamically extends assets with type-specific methods
- supports multiple asset types with different attributes
- imports complete asset hierarchies from OpenRemote JSON format

### Data analytics

Data Analytics

**Key Capabilities:**

- collects and stores time-series measurements for assets
- supports multiple attributes per asset
- calculates sum of values over time range
- calculates average of values over time range
- finds maximum value over time range

### Integration workflows

End-to-End Integration Workflows

**Key Capabilities:**

- demonstrates full lifecycle: import, monitor, analyze, alert
- manages diverse asset portfolio with different capabilities
- demonstrates complete user lifecycle with role-based access
- executes rules and generates notifications for stakeholders
- uses historical data to inform operational decisions

### Rule engine

Rule Engine

**Key Capabilities:**

- executes rules based on cron schedules
- supports interval-based schedules
- supports time-of-day schedules
- triggers rules when asset attribute values match conditions
- triggers rules when asset attributes change


---

## Rule Engine

The application provides comprehensive rule engine capabilities:

### Integration workflows

End-to-End Integration Workflows

**Key Capabilities:**

- demonstrates full lifecycle: import, monitor, analyze, alert
- manages diverse asset portfolio with different capabilities
- demonstrates complete user lifecycle with role-based access
- executes rules and generates notifications for stakeholders
- uses historical data to inform operational decisions

### Rule engine

Rule Engine

**Key Capabilities:**

- executes rules based on cron schedules
- supports interval-based schedules
- supports time-of-day schedules
- triggers rules when asset attribute values match conditions
- triggers rules when asset attributes change


---

## Notifications

The application provides comprehensive notifications capabilities:

### Integration workflows

End-to-End Integration Workflows

**Key Capabilities:**

- demonstrates full lifecycle: import, monitor, analyze, alert
- manages diverse asset portfolio with different capabilities
- demonstrates complete user lifecycle with role-based access
- executes rules and generates notifications for stakeholders
- uses historical data to inform operational decisions

### Rule engine

Rule Engine

**Key Capabilities:**

- executes rules based on cron schedules
- supports interval-based schedules
- supports time-of-day schedules
- triggers rules when asset attribute values match conditions
- triggers rules when asset attributes change


---

## Authentication

The application provides comprehensive authentication capabilities:

### Integration workflows

End-to-End Integration Workflows

**Key Capabilities:**

- demonstrates full lifecycle: import, monitor, analyze, alert
- manages diverse asset portfolio with different capabilities
- demonstrates complete user lifecycle with role-based access
- executes rules and generates notifications for stakeholders
- uses historical data to inform operational decisions


---

## Authorization

The application provides comprehensive authorization capabilities:

### Integration workflows

End-to-End Integration Workflows

**Key Capabilities:**

- demonstrates full lifecycle: import, monitor, analyze, alert
- manages diverse asset portfolio with different capabilities
- demonstrates complete user lifecycle with role-based access
- executes rules and generates notifications for stakeholders
- uses historical data to inform operational decisions


---

## Integration

The application provides comprehensive integration capabilities:

### Integration workflows

End-to-End Integration Workflows

**Key Capabilities:**

- demonstrates full lifecycle: import, monitor, analyze, alert
- manages diverse asset portfolio with different capabilities
- demonstrates complete user lifecycle with role-based access
- executes rules and generates notifications for stakeholders
- uses historical data to inform operational decisions


---

## End-to-End Workflows

The application supports complex, multi-step workflows that combine multiple
capabilities:

### Complete Solar Park Monitoring
1. **Import** asset hierarchies from OpenRemote JSON format
2. **Monitor** assets with time-series data collection
3. **Analyze** performance using aggregation functions (sum, avg, min, max)
4. **Alert** stakeholders via notifications when conditions are met
5. **Export** updated asset data back to OpenRemote format

### Multi-Asset Energy Management
- Manage diverse asset portfolios (solar, meters, inverters, weather stations)
- Cross-asset rule execution and monitoring
- Energy balance calculations and reporting

### User Lifecycle Management
1. **Registration** with email confirmation
2. **Authentication** with password reset and "remember me"
3. **Authorization** via role-based access control (Admin, Manager, Viewer)
4. **Account Security** with automatic locking after failed attempts

### Data-Driven Decision Making
- Historical data collection and analysis
- Pattern recognition and threshold detection
- Automated rule creation based on data insights
- Performance monitoring and alerting

---

## Technical Capabilities

### Asset Management
- ✅ Hierarchical asset structures (parent-child relationships)
- ✅ Type-specific attribute extensions (SolarPark, SolarArray, Inverter, etc.)
- ✅ OpenRemote JSON import/export compatibility
- ✅ Advanced querying (by type, attribute thresholds, power outputs)
- ✅ Cascading deletion of child assets

### Rule Engine
- ✅ Schedule-based rules (cron, interval, time-of-day)
- ✅ Attribute-based rules (value conditions, change detection)
- ✅ Rule execution tracking with status and results
- ✅ OpenRemote rule format import/export
- ✅ Timezone-aware scheduling

### Data Analytics
- ✅ Time-series data collection and storage
- ✅ Aggregation functions (sum, average, min, max)
- ✅ Time range queries and filtering
- ✅ Latest data point retrieval
- ✅ Bulk data recording for asset types
- ✅ TimescaleDB continuous aggregates support

### Notifications
- ✅ Multi-severity notifications (info, warning, error)
- ✅ Asset and rule association
- ✅ Timestamp tracking
- ✅ Queryable notification history

### Authentication & Authorization
- ✅ Email confirmation workflow
- ✅ Password reset with expiration
- ✅ "Remember me" functionality (2-week tokens)
- ✅ Account locking (5 failed attempts, 2-hour lock)
- ✅ Role-based access control (Rolify integration)
- ✅ CanCanCan ability definitions

---

## Test-Driven Documentation

All capabilities listed above are verified through comprehensive test coverage.
See `spec/features/` for detailed test scenarios demonstrating each capability.

To regenerate this document:
```bash
bundle exec rails runner "require_relative 'lib/tasks/capability_extractor'; puts CapabilityExtractor.new.generate_markdown" > docs/capabilities.md
```
