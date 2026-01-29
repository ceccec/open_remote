---
title: Active Record Query Interface - Code Review
lastUpdated: 2026-01-28
---

# Active Record Query Interface - Code Review

**Date**: January 28, 2026  
**Guide**: [Active Record Query Interface](https://guides.rubyonrails.org/active_record_querying.html)  
**Status**: ✅ Well Implemented with Minor Improvements Needed

## Executive Summary

The application demonstrates strong use of Active Record query methods with proper parameterization, batch processing, and efficient query patterns. The codebase uses Arel for complex queries, implements proper scopes, and follows Rails best practices. There are a few opportunities to optimize queries with eager loading and improve memory efficiency in some batch operations.

## Current State

### ✅ Strengths

1. **SQL Injection Prevention**
   - ✅ Consistent use of parameterized queries with `?` placeholders
   - ✅ Proper use of hash conditions
   - ✅ No raw SQL string interpolation found

2. **Batch Processing**
   - ✅ Excellent use of `find_each` for batch iteration
   - ✅ Custom batch action methods using `find_each`
   - ✅ Proper batch deletion with `delete_all` and `update_all`

3. **Scopes**
   - ✅ Well-defined scopes on models (Asset, DataPoint, Rule, User)
   - ✅ Chainable scopes
   - ✅ Scopes with parameters

4. **Query Methods**
   - ✅ Proper use of `joins` for associations
   - ✅ Appropriate use of `where` with hash and array conditions
   - ✅ Efficient use of `pluck` for retrieving specific columns
   - ✅ Proper use of `find_by` instead of `find` when appropriate

5. **Complex Queries**
   - ✅ Excellent use of Arel for complex PostgreSQL-specific queries
   - ✅ Proper handling of JSONB queries
   - ✅ Efficient aggregations using Arel

6. **Calculations**
   - ✅ Proper use of `count`, `sum`, `average`, `max`, `min` via Arel
   - ✅ Grouping and aggregation queries

### ⚠️ Areas for Improvement

1. **Eager Loading**: Some queries could benefit from `includes`/`preload` to avoid N+1 queries
2. **Memory Efficiency**: One method loads all records into memory before filtering
3. **Query Optimization**: Some queries could be optimized with better eager loading

## Detailed Analysis

### 1. SQL Injection Prevention

**Status**: ✅ Excellent

All queries use parameterized conditions:

```ruby
# ✅ Good: Parameterized query
Rule.where(enabled: true)
    .where("when_config->>'condition' = ?", "Schedule")
    .where("when_config->>'attribute' = ?", attribute_name)

# ✅ Good: Hash conditions
Asset.joins(:asset_type).where(asset_types: { name: "SolarArray" })

# ✅ Good: Array conditions with placeholders
DataPoint.where("timestamp < ?", timestamp)
```

**No SQL injection vulnerabilities found.**

### 2. Batch Processing

**Status**: ✅ Excellent

The application has excellent batch processing patterns:

**File**: `app/models/concerns/batch_actions.rb`
```ruby
# ✅ Good: Using find_each for batch processing
def batch_execute(ids, action, *args)
  relation.find_each do |record|
    # Process each record
  end
end
```

**File**: `app/services/asset_processing_service.rb`
```ruby
# ✅ Good: Using find_each for batch rule processing
rules.find_each do |rule|
  if rule_should_trigger?(rule, asset, attribute_name, value)
    RuleExecutionJob.perform_later(rule)
  end
end
```

**File**: `app/models/data_point/batch_actions.rb`
```ruby
# ✅ Good: Efficient batch deletion with pluck and delete_all
def batch_cleanup_older_than(timestamp, batch_size: 1000)
  loop do
    batch_ids = relation.limit(batch_size).pluck(:id)
    break if batch_ids.empty?
    deleted = where(id: batch_ids).delete_all
    total_deleted += deleted
    break if deleted < batch_size
  end
end
```

### 3. Scopes

**Status**: ✅ Excellent

Well-defined scopes throughout the application:

**File**: `app/models/asset.rb`
```ruby
scope :root_assets, -> { where(parent_id: nil) }
scope :with_parent, -> { where.not(parent_id: nil) }
scope :by_type, ->(type_name) { joins(:asset_type).where(asset_types: { name: type_name }) }
```

**File**: `app/models/rule.rb`
```ruby
scope :enabled, -> { where(enabled: true) }
scope :disabled, -> { where(enabled: false) }
scope :scheduled, -> { where("when_config->>'condition' = ?", "Schedule") }
scope :attribute_changed, -> { where("when_config->>'condition' = ?", "Asset attribute value changed") }
```

**File**: `app/models/user.rb`
```ruby
scope :confirmed, -> { where.not(confirmed_at: nil) }
scope :unconfirmed, -> { where(confirmed_at: nil) }
scope :with_role, ->(role_name) { joins(:roles).where(roles: { name: role_name }) }
```

### 4. Joins and Associations

**Status**: ✅ Good

Proper use of `joins` for filtering:

```ruby
# ✅ Good: Using joins with hash conditions
Asset.joins(:asset_type).where(asset_types: { name: "SolarArray" })

# ✅ Good: Joins with scopes
Rule.joins(:rule_executions).order("rule_executions.executed_at DESC").distinct
```

### 5. Complex Queries with Arel

**Status**: ✅ Excellent

Excellent use of Arel for complex PostgreSQL queries:

**File**: `app/models/asset/querying.rb`
```ruby
# ✅ Good: Complex Arel query for JSONB extraction
def solar_array_power_outputs
  t = arel_table
  asset_types_t = AssetType.arel_table
  
  expr = Arel::Nodes::SqlLiteral.new(
    "(#{table_name}.attributes_data ->> #{connection.quote('powerOutput')})::float"
  )
  
  query = t
          .project(t[:id], expr.as("power_output"))
          .join(asset_types_t).on(asset_types_t[:id].eq(t[:asset_type_id]))
          .where(asset_types_t[:name].eq("SolarArray"))
  
  connection.select_all(query.to_sql).map do |row|
    [ row["id"], row["power_output"].to_f ]
  end
end
```

**File**: `app/models/data_point/analytics.rb`
```ruby
# ✅ Good: Arel aggregations
def sum_for(asset:, attribute_name:, from:, to:)
  t = arel_table
  value_expr = Arel::Nodes::SqlLiteral.new("(value->>'value')::float")
  
  query = t
          .project(value_expr.sum.as("sum_value"))
          .where(
            t[:asset_id].eq(asset.id)
              .and(t[:attribute_name].eq(attribute_name))
              .and(t[:timestamp].gteq(from))
              .and(t[:timestamp].lteq(to))
          )
  
  result = connection.select_one(query.to_sql)
  result&.dig("sum_value")&.to_f || 0
end
```

### 6. Calculations

**Status**: ✅ Good

Proper use of calculations via Arel:

```ruby
# ✅ Good: Using Arel for aggregations
value_expr.sum.as("sum_value")
value_expr.average.as("avg_value")
value_expr.maximum.as("max_value")
value_expr.minimum.as("min_value")
```

**File**: `app/models/rule.rb`
```ruby
# ✅ Good: Grouping with count
def execution_counts
  rule_executions.group(:status).count
end
```

### 7. Finder Methods

**Status**: ✅ Good

Proper use of finder methods:

```ruby
# ✅ Good: Using find_by for single records
User.find_by(email: params[:email])
User.find_by_reset_password_token(token)

# ✅ Good: Using find for primary keys
User.find_by(id: session[:user_id])

# ✅ Good: Using where with take for single records
Rule.where(enabled: true).where("when_config->>'condition' = ?", "Schedule").take
```

### 8. Pluck and Select

**Status**: ✅ Good

Efficient use of `pluck`:

```ruby
# ✅ Good: Using pluck for batch operations
batch_ids = relation.limit(batch_size).pluck(:id)

# ✅ Good: Using pluck for distinct values
groups = where(timestamp: from_time..to_time)
  .select(:asset_id, :attribute_name)
  .distinct
  .pluck(:asset_id, :attribute_name)
```

## Issues Found

### Issue 1: N+1 Query in `process_outdated_attributes`

**File**: `app/services/asset_processing_service.rb`

**Current Code**:
```ruby
def self.process_outdated_attributes(threshold: 1.hour)
  # ...
  latest_datapoints.group_by(&:attribute_name).each do |attribute_name, data_points|
    outdated_assets = data_points.select { |dp| dp.timestamp < cutoff_time }
                                 .map(&:asset)  # ⚠️ N+1 query
                                 .uniq
    # ...
  end
end
```

**Problem**: `.map(&:asset)` triggers an N+1 query, loading each asset individually.

**Recommendation**:
```ruby
def self.process_outdated_attributes(threshold: 1.hour)
  cutoff_time = Time.current - threshold
  outdated = {}

  # Get latest data points for each asset/attribute combination
  latest_datapoints = DataPoint.select("DISTINCT ON (asset_id, attribute_name) *")
                                .order(:asset_id, :attribute_name, timestamp: :desc)
                                .includes(:asset)  # ✅ Eager load assets

  # Group by attribute and filter by cutoff time
  latest_datapoints.group_by(&:attribute_name).each do |attribute_name, data_points|
    outdated_assets = data_points.select { |dp| dp.timestamp < cutoff_time }
                                 .map(&:asset)
                                 .uniq

    outdated[attribute_name] = outdated_assets if outdated_assets.any?
  end

  outdated
end
```

### Issue 2: Loading All Records into Memory

**File**: `app/services/rule_manager.rb`

**Current Code**:
```ruby
def self.find_due_rules
  Rule.where(enabled: true)
      .where("when_config->>'condition' = ?", "Schedule")
      .where.not(schedule: [ nil, "" ])
      .to_a  # ⚠️ Loads all records into memory
      .select { |rule| rule_due?(rule) }
end
```

**Problem**: `.to_a` loads all matching records into memory before filtering.

**Recommendation**:
```ruby
def self.find_due_rules
  Rule.where(enabled: true)
      .where("when_config->>'condition' = ?", "Schedule")
      .where.not(schedule: [ nil, "" ])
      .find_each  # ✅ Process in batches
      .select { |rule| rule_due?(rule) }
      .to_a  # Only convert to array if needed
end
```

Or better yet, move the `rule_due?` logic into SQL if possible:
```ruby
def self.find_due_rules
  # If rule_due? can be expressed in SQL, do it here
  Rule.where(enabled: true)
      .where("when_config->>'condition' = ?", "Schedule")
      .where.not(schedule: [ nil, "" ])
      # Add SQL conditions for due rules if possible
end
```

### Issue 3: Potential Eager Loading Opportunities

**File**: `app/models/rule.rb`

**Current Code**:
```ruby
def last_execution
  rule_executions.order(executed_at: :desc).first
end

def last_successful_execution
  rule_executions.successful.order(executed_at: :desc).first
end
```

**Recommendation**: If these methods are called in loops, consider eager loading:

```ruby
# In controller or service
rules = Rule.includes(:rule_executions).where(...)
rules.each do |rule|
  rule.last_execution  # ✅ No additional query
end
```

## Recommendations Priority

### High Priority

1. **Fix N+1 query in `process_outdated_attributes`**
   - Add `includes(:asset)` to eager load assets
   - Prevents N+1 queries when processing outdated attributes

2. **Optimize `find_due_rules` memory usage**
   - Use `find_each` instead of `.to_a.select`
   - Or move filtering logic to SQL if possible

### Medium Priority

3. **Add eager loading where appropriate**
   - Review controller actions that iterate over collections
   - Add `includes`/`preload` for commonly accessed associations
   - Consider `strict_loading` in development to catch N+1 queries

4. **Consider using `strict_loading` in development**
   - Helps catch N+1 queries during development
   - Can be enabled per-relation or globally

### Low Priority

5. **Document query patterns**
   - Document complex Arel queries
   - Document batch processing strategies
   - Document scope usage patterns

6. **Consider query performance monitoring**
   - Use `explain` for complex queries
   - Monitor slow queries in production
   - Consider adding database indexes if needed

## Implementation Examples

### Example 1: Fix N+1 Query

```ruby
# app/services/asset_processing_service.rb
def self.process_outdated_attributes(threshold: 1.hour)
  cutoff_time = Time.current - threshold
  outdated = {}

  latest_datapoints = DataPoint.select("DISTINCT ON (asset_id, attribute_name) *")
                                .order(:asset_id, :attribute_name, timestamp: :desc)
                                .includes(:asset)  # ✅ Eager load

  latest_datapoints.group_by(&:attribute_name).each do |attribute_name, data_points|
    outdated_assets = data_points.select { |dp| dp.timestamp < cutoff_time }
                                 .map(&:asset)
                                 .uniq

    outdated[attribute_name] = outdated_assets if outdated_assets.any?
  end

  outdated
end
```

### Example 2: Optimize Memory Usage

```ruby
# app/services/rule_manager.rb
def self.find_due_rules
  due_rules = []
  
  Rule.where(enabled: true)
      .where("when_config->>'condition' = ?", "Schedule")
      .where.not(schedule: [ nil, "" ])
      .find_each do |rule|  # ✅ Process in batches
    due_rules << rule if rule_due?(rule)
  end
  
  due_rules
end
```

### Example 3: Add Eager Loading

```ruby
# In controllers or services where rules are iterated
rules = Rule.includes(:rule_executions)
            .enabled
            .scheduled

rules.each do |rule|
  # ✅ No N+1 query for rule_executions
  rule.last_execution
  rule.execution_counts
end
```

## Conclusion

The application demonstrates excellent use of Active Record query methods with proper SQL injection prevention, efficient batch processing, and well-structured scopes. The use of Arel for complex queries is particularly commendable.

The main areas for improvement are:
1. **Immediate**: Fix N+1 query in `process_outdated_attributes`
2. **Short-term**: Optimize `find_due_rules` memory usage
3. **Long-term**: Add eager loading where appropriate and consider `strict_loading` in development

All recommendations align with Rails best practices and the Active Record Query Interface guide.
