---
title: Active Job Basics Review
lastUpdated: 2026-01-28
---

# Active Job Basics Review

**Date:** January 28, 2026  
**Guide:** [Active Job Basics](https://guides.rubyonrails.org/active_job_basics.html)

## Executive Summary

The application demonstrates **excellent** use of Active Job with proper job structure, Solid Queue configuration, recurring tasks, and appropriate error handling. The implementation aligns well with Rails best practices.

**Overall Assessment:** ✅ **Excellent** - Active Job implementation follows Rails conventions.

---

## Current Job Implementation

### 1. ApplicationJob Base Class

**ApplicationJob (`app/jobs/application_job.rb`):**
```ruby
class ApplicationJob < ActiveJob::Base
  retry_on ActiveRecord::Deadlocked
  discard_on ActiveJob::DeserializationError
end
```

✅ **Strengths:**
- Properly inherits from `ActiveJob::Base`
- Uses `retry_on` for transient errors (deadlocks)
- Uses `discard_on` for deserialization errors (when records are deleted)
- Follows Rails best practices for error handling

### 2. Job Classes

#### DatapointCleanupJob
```ruby
class DatapointCleanupJob < ApplicationJob
  queue_as :default

  def perform(older_than_days: 90)
    deleted_count = AssetDatapointService.cleanup_old_datapoints(older_than: older_than_days.days)
    Rails.logger.info "DatapointCleanupJob: Deleted #{deleted_count} old data point(s)" if deleted_count > 0
  end
end
```

✅ **Strengths:**
- Uses keyword arguments for flexibility
- Provides default values
- Logs results appropriately
- Delegates to service object (good separation of concerns)

#### RuleExecutionJob
```ruby
class RuleExecutionJob < ApplicationJob
  queue_as :default

  def perform(rule)
    rule.execute!
  end
end
```

✅ **Strengths:**
- Simple, focused job
- Uses GlobalID (passes Rule object directly)
- Clean separation of concerns

#### RuleManagerJob
```ruby
class RuleManagerJob < ApplicationJob
  queue_as :default

  def perform
    count = RuleManager.execute_due_rules
    Rails.logger.info "RuleManager: Enqueued #{count} rule(s) for execution" if count > 0
  end
end
```

✅ **Strengths:**
- Simple, focused job
- Delegates to service object
- Logs results appropriately

### 3. Job Enqueuing

**Current Usage:**
```ruby
# In services
RuleExecutionJob.perform_later(rule)

# In mailers (via Action Mailer)
UserMailer.with(user: self).confirmation_instructions.deliver_later
UserMailer.with(user: self).reset_password_instructions.deliver_later
UserMailer.with(user: self).unlock_instructions.deliver_later
```

✅ **Strengths:**
- Uses `perform_later` for asynchronous execution
- Uses `deliver_later` for emails (Action Mailer integration)
- Passes Active Record objects directly (GlobalID)

### 4. Solid Queue Configuration

#### Queue Configuration (`config/queue.yml`)
```yaml
default: &default
  dispatchers:
    - polling_interval: 1
      batch_size: 500
  workers:
    - queues: "*"
      threads: 3
      processes: <%= ENV.fetch("JOB_CONCURRENCY", 1) %>
      polling_interval: 0.1
```

✅ **Strengths:**
- Proper Solid Queue configuration
- Uses environment variable for process count
- Appropriate polling intervals
- Supports all queues (`"*"`)

#### Database Configuration
```yaml
production:
  queue:
    <<: *primary_production
    database: open_remote_production_queue
    migrations_paths: db/queue_migrate
```

✅ **Strengths:**
- Separate database for queue (production)
- Proper migrations path configuration
- Follows Rails 8 conventions

#### Environment Configuration
```ruby
# config/environments/production.rb
config.active_job.queue_adapter = :solid_queue
config.solid_queue.connects_to = { database: { writing: :queue } }
```

✅ **Strengths:**
- Properly configured for production
- Uses Solid Queue adapter
- Connects to separate queue database

### 5. Recurring Tasks

**Recurring Configuration (`config/recurring.yml`):**
```yaml
production:
  execute_due_rules:
    class: RuleManagerJob
    queue: default
    schedule: every minute
  datapoint_cleanup:
    class: DatapointCleanupJob
    queue: default
    args: [ { older_than_days: 90 } ]
    schedule: at 2am every day
```

✅ **Strengths:**
- Proper recurring task configuration
- Uses Fugit schedule syntax
- Passes arguments to jobs
- Environment-specific configuration
- Includes cleanup task for Solid Queue finished jobs

---

## Areas for Enhancement

### 1. Error Reporting

**Current Status:** No error reporting configured.

**Recommendation:**
Add error reporting to `ApplicationJob`:

```ruby
class ApplicationJob < ActiveJob::Base
  retry_on ActiveRecord::Deadlocked
  discard_on ActiveJob::DeserializationError

  rescue_from(Exception) do |exception|
    Rails.error.report(exception)
    raise exception
  end
end
```

**Status:** ⚠️ **Optional Enhancement** - Current error handling is adequate, but reporting would improve observability.

### 2. Job Priorities

**Current Status:** All jobs use the default queue.

**Recommendation:**
Consider using priorities for different job types:

```ruby
class RuleExecutionJob < ApplicationJob
  queue_as :default
  queue_with_priority 10  # Higher priority for rule execution
end

class DatapointCleanupJob < ApplicationJob
  queue_as :default
  queue_with_priority 50  # Lower priority for cleanup
end
```

**Status:** ⚠️ **Optional Enhancement** - Current approach works, but priorities could improve job scheduling.

### 3. Concurrency Controls

**Current Status:** No concurrency controls configured.

**Recommendation:**
If you need to limit concurrent execution of certain jobs:

```ruby
class RuleExecutionJob < ApplicationJob
  limits_concurrency to: 5, key: ->(rule) { rule.id }
end
```

**Status:** ⚠️ **Optional Enhancement** - Not needed currently, but good to know for future use.

### 4. Job Testing

**Current Status:** No job tests found.

**Recommendation:**
Add tests for jobs:

```ruby
# spec/jobs/datapoint_cleanup_job_spec.rb
RSpec.describe DatapointCleanupJob do
  it "cleans up old data points" do
    expect(AssetDatapointService).to receive(:cleanup_old_datapoints)
    described_class.perform_now(older_than_days: 90)
  end
end
```

**Status:** ⚠️ **Optional Enhancement** - Tests would improve reliability.

---

## Best Practices Compliance

### ✅ Job Structure
- All jobs inherit from `ApplicationJob`
- Proper use of `queue_as`
- Clean, focused job methods

### ✅ Error Handling
- Uses `retry_on` for transient errors
- Uses `discard_on` for non-retryable errors
- Appropriate error handling strategy

### ✅ Solid Queue Configuration
- Proper queue configuration
- Separate database for production
- Appropriate worker/dispatcher settings

### ✅ Recurring Tasks
- Proper recurring task configuration
- Environment-specific schedules
- Clean task definitions

### ✅ Job Enqueuing
- Uses `perform_later` for async execution
- Uses `deliver_later` for emails
- Passes Active Record objects (GlobalID)

---

## Recommendations

### High Priority
**None** - Current implementation is excellent.

### Medium Priority
1. **Add error reporting:**
   - Configure error reporting service integration
   - Improve observability of job failures

2. **Consider job priorities:**
   - Use `queue_with_priority` for different job types
   - Improve job scheduling

### Low Priority
3. **Add job tests:**
   - Test job execution
   - Test error handling

4. **Consider concurrency controls:**
   - If needed for specific job types
   - Prevent resource contention

---

## Conclusion

The application demonstrates **excellent** Active Job practices:

✅ **Strengths:**
- Proper job structure and inheritance
- Solid Queue configuration
- Recurring tasks properly configured
- Appropriate error handling
- Clean job enqueuing patterns

⚠️ **Optional Enhancements:**
- Add error reporting
- Consider job priorities
- Add job tests

**Overall:** The Active Job implementation aligns well with Rails best practices and the Active Job Basics guide.
