# DatapointCleanupJob

# Recurring job to clean up old data points.

**Type:** Jobs  
**File:** `datapoint_cleanup_job.rb`

This job inherits from `ApplicationJob`, enabling asynchronous background processing. Jobs are enqueued and executed by Active Job adapters. See [ApplicationJob](https://api.rubyonrails.org/classes/ApplicationJob.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationJob](https://api.rubyonrails.org/classes/ApplicationJob.html) - Job enqueueing, callbacks, and execution
- **Queue Adapters**: [ActiveJob::QueueAdapters](https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters.html) - Background job processing adapters


::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 3
- **Test file**: `spec/jobs/datapoint_cleanup_job_spec.rb`
- **Last tested**: 2026-01-28 22:11:53

:::






## Methods

- `perform`


## Examples

The following examples are extracted from test files:

### deletes data points older than 90 days

```ruby
        expect(Rails.logger).to receive(:info).with("DatapointCleanupJob: Deleted 1 old data point(s)")
        expect(DataPoint.find_by(id: old_datapoint.id)).to be_nil
        expect(DataPoint.find_by(id: new_datapoint.id)).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/datapoint_cleanup_job_spec.rb:8`_


### deletes data points older than specified days

```ruby
        expect(Rails.logger).to receive(:info).with("DatapointCleanupJob: Deleted 1 old data point(s)")
        expect(DataPoint.find_by(id: old_datapoint.id)).to be_nil
        expect(DataPoint.find_by(id: new_datapoint.id)).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/datapoint_cleanup_job_spec.rb:31`_


### does not log anything

```ruby
        expect(Rails.logger).not_to receive(:info)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/datapoint_cleanup_job_spec.rb:54`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/jobs/datapoint_cleanup_job.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/datapoint_cleanup_job_spec.rb`

---

[← Back to Index](/)
