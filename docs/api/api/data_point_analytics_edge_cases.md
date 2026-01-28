# DataPointAnalyticsEdgeCases

API documentation for DataPointAnalyticsEdgeCases

## Examples

The following examples are extracted from test files:

### handles zero values correctly

```ruby
      expect(sum).to eq(0.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:14`_


### handles negative values correctly

```ruby
      expect(sum).to eq(100.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:32`_


### handles decimal values correctly

```ruby
      expect(sum).to eq(301.25)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:56`_


### handles string numeric values

```ruby
      expect(sum).to eq(100.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:80`_


### filters by exact time boundaries

```ruby
      expect(sum).to eq(500.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:98`_


### returns nil when no datapoints match

```ruby
      expect(avg).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:139`_


### handles single datapoint

```ruby
      expect(avg).to eq(100.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:150`_


### calculates correct average with multiple values

```ruby
      expect(avg).to eq(200.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:168`_


### returns nil when no datapoints match

```ruby
      expect(max).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:139`_


### finds maximum value correctly

```ruby
      expect(max).to eq(500.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:211`_


### handles negative maximum values

```ruby
      expect(max).to eq(-50.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:241`_


### returns nil when no datapoints match

```ruby
      expect(min).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:139`_


### finds minimum value correctly

```ruby
      expect(min).to eq(100.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:278`_


### handles negative minimum values

```ruby
      expect(min).to eq(-100.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:308`_


### handles TimescaleDB not being available gracefully

```ruby
      expect(Rails.logger).to receive(:warn).with(
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:334`_


### handles SQL syntax errors gracefully

```ruby
      expect(Rails.logger).to receive(:warn).with(
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:351`_


### filters by asset correctly

```ruby
      expect(sum1).to eq(100.0)
      expect(sum2).to eq(200.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:378`_


### filters by attribute_name correctly

```ruby
      expect(power_sum).to eq(100.0)
      expect(temp_sum).to eq(25.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb:409`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_analytics_edge_cases_spec.rb`

---

[← Back to Index](/)
