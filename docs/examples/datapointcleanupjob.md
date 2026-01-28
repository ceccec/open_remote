# DatapointCleanupJob Examples

Test-driven examples for DatapointCleanupJob functionality.

### deletes data points older than 90 days

```ruby
        expect(Rails.logger).to receive(:info).with("DatapointCleanupJob: Deleted 1 old data point(s)")
        expect(DataPoint.find_by(id: old_datapoint.id)).to be_nil
        expect(DataPoint.find_by(id: new_datapoint.id)).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/datapoint_cleanup_job_spec.rb:8`_


---

### deletes data points older than specified days

```ruby
        expect(Rails.logger).to receive(:info).with("DatapointCleanupJob: Deleted 1 old data point(s)")
        expect(DataPoint.find_by(id: old_datapoint.id)).to be_nil
        expect(DataPoint.find_by(id: new_datapoint.id)).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/datapoint_cleanup_job_spec.rb:31`_


---

### does not log anything

```ruby
        expect(Rails.logger).not_to receive(:info)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/datapoint_cleanup_job_spec.rb:54`_


---

[← Back to Index](/)
