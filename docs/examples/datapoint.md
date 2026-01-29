# DataPoint Examples

Test-driven examples for DataPoint functionality.

### deletes data points older than the given timestamp

```ruby
      expect { DataPoint.batch_cleanup_older_than(1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:11`_


---

### does not delete recent data points

```ruby
      expect { DataPoint.batch_cleanup_older_than(1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:17`_


---

### returns the number of records deleted

```ruby
      expect(DataPoint.batch_cleanup_older_than(1.month.ago)).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:22`_


---

### handles large batches



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:26`_


---

### deletes old data points for a specific asset

```ruby
      expect { DataPoint.batch_cleanup_for_asset(asset, 1.month.ago) }
      expect { DataPoint.batch_cleanup_for_asset(asset, 1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:45`_


---

### works with asset ID

```ruby
      expect { DataPoint.batch_cleanup_for_asset(asset.id, 1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:52`_


---

### deletes old data points for a specific attribute

```ruby
      expect { DataPoint.batch_cleanup_for_attribute("power", 1.month.ago) }
      expect { DataPoint.batch_cleanup_for_attribute("power", 1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:61`_


---

### transforms values using a block



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:70`_


---

### handles errors gracefully

```ruby
      expect(results[:failed]).to eq(1)
      expect(results[:errors].first[:error]).to eq("Test error")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:80`_


---

### deletes duplicate data points, keeping the most recent

```ruby
      expect { DataPoint.batch_delete_duplicates }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:94`_


---

### keeps the data point with the highest ID

```ruby
      expect(remaining.count).to eq(1)
      expect(remaining.first.id).to eq([ duplicate1.id, duplicate2.id, duplicate3.id ].max)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:99`_


---

### creates aggregated data points by time window

```ruby
      expect(results[:created]).to be > 0
      expect(aggregated.count).to be > 0
      expect(aggregated.first.value["aggregated"]).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:122`_


---

### calculates average correctly

```ruby
      expect(aggregated).not_to be_nil
      expect(aggregated.value["value"]).to be_within(0.01).of(150.0) # (100 + 200) / 2
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:131`_


---

### supports sum aggregation

```ruby
      expect(aggregated).not_to be_nil
      expect(aggregated.value["value"]).to eq(300.0) # 100 + 200
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:142`_


---

### includes asset name, attribute_name and formatted timestamp

```ruby
      expect(label).to include("Main Park")
      expect(label).to include("powerOutput")
      expect(label).to include("2026-01-28 15:45")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_label_spec.rb:22`_


---

### is valid with valid attributes

```ruby
      expect(data_point).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:14`_


---

### is invalid without attribute_name

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:24`_


---

### is invalid without value

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:33`_


---

### is invalid without timestamp

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:42`_


---

### belongs to asset

```ruby
      expect(data_point.asset).to eq(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:53`_


---

### calculates sum for time range

```ruby
      expect(sum).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:76`_


---

### calculates average for time range

```ruby
      expect(avg).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:88`_


---

### finds max value for time range

```ruby
      expect(max).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:100`_


---

### finds min value for time range

```ruby
      expect(min).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:112`_


---

### returns neutral values when there are no matching datapoints

```ruby
      expect(sum).to eq(0.0)
      expect(avg).to be_nil
      expect(max).to be_nil
      expect(min).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:124`_


---

### logs a warning instead of raising when continuous aggregate creation fails

```ruby
      expect(Rails.logger).to receive(:warn).with(
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:159`_


---

[← Back to Index](/)
