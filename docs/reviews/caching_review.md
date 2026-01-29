---
title: Caching with Rails - Code Review
lastUpdated: 2026-01-28
---

# Caching with Rails - Code Review

**Date**: January 28, 2026  
**Guide**: [Caching with Rails](https://guides.rubyonrails.org/caching_with_rails.html)  
**Status**: ✅ Well Configured with Opportunities for Enhancement

## Executive Summary

The application has a solid caching foundation with Solid Cache properly configured for production. However, there are opportunities to leverage Rails caching features more extensively, particularly for fragment caching, low-level caching of expensive queries, and improved conditional GET support.

## Current State

### ✅ Strengths

1. **Solid Cache Configuration**
   - ✅ Production uses `:solid_cache_store` with separate cache database
   - ✅ Development uses `:memory_store` (default, appropriate)
   - ✅ Test uses `:null_store` (correct for tests)
   - ✅ Cache database properly configured in `config/database.yml`
   - ✅ Cache schema exists (`db/cache_schema.rb`)
   - ✅ Cache configuration file exists (`config/cache.yml`)

2. **Action Controller Caching**
   - ✅ Fragment caching enabled in production (`config.action_controller.perform_caching = true`)
   - ✅ Development caching can be toggled with `bin/rails dev:cache`

3. **Conditional GET Support**
   - ✅ Uses `stale_when_importmap_changes` in `ApplicationController` for importmap changes
   - ✅ Manual Cache-Control header in `DocsController` for static documentation

4. **Cache Store Setup**
   - ✅ Solid Cache gem installed (`gem "solid_cache"`)
   - ✅ Proper database connection configuration for cache

### ⚠️ Areas for Improvement

1. **Fragment Caching**: Not currently used in views
2. **Low-Level Caching**: No `Rails.cache.fetch` usage for expensive queries
3. **Conditional GET**: Could use Rails helpers instead of manual headers
4. **Cache Configuration**: `max_age` is commented out in `config/cache.yml`
5. **Collection Caching**: Not implemented for any collections
6. **Russian Doll Caching**: Not applicable yet (no nested partials)

## Detailed Analysis

### 1. Cache Store Configuration

**File**: `config/environments/production.rb`
```ruby
config.cache_store = :solid_cache_store
```
✅ **Status**: Correctly configured

**File**: `config/cache.yml`
```yaml
default: &default
  store_options:
    # max_age: <%= 60.days.to_i %>  # Commented out
    max_size: <%= 256.megabytes %>
    namespace: <%= Rails.env %>

production:
  database: cache
  <<: *default
```
⚠️ **Recommendation**: Uncomment and configure `max_age` based on your retention policies.

**File**: `config/database.yml`
```yaml
production:
  cache:
    <<: *primary_production
    database: open_remote_production_cache
    migrations_paths: db/cache_migrate
```
✅ **Status**: Properly configured with separate cache database

### 2. Conditional GET Support

**File**: `app/controllers/application_controller.rb`
```ruby
stale_when_importmap_changes
```
✅ **Status**: Good use of conditional GET for importmap changes

**File**: `app/controllers/docs_controller.rb`
```ruby
response.headers["Cache-Control"] = "public, max-age=3600" if Rails.env.production?
```
⚠️ **Recommendation**: Use Rails helpers instead:
```ruby
def index
  index_path = Rails.root.join("public", "index.html")
  
  if File.exist?(index_path)
    file_mtime = File.mtime(index_path)
    if stale?(last_modified: file_mtime, public: true)
      response.headers["Cache-Control"] = "public, max-age=3600"
      render file: index_path, layout: false, content_type: "text/html"
    end
  else
    redirect_to "/api", status: :found
  end
end
```

### 3. Fragment Caching

**Status**: ❌ Not currently used

**Recommendation**: Consider fragment caching for:
- Asset listings in RailsAdmin
- Rule execution history
- Data point visualizations
- Any views that render collections

**Example**:
```erb
<% @assets.each do |asset| %>
  <% cache asset do %>
    <%= render partial: "assets/asset", locals: { asset: asset } %>
  <% end %>
<% end %>
```

Or with collection caching:
```erb
<%= render partial: "assets/asset", collection: @assets, cached: true %>
```

### 4. Low-Level Caching

**Status**: ❌ Not currently used

**Potential Opportunities**:

1. **Expensive Queries** (`app/models/asset/querying.rb`):
   ```ruby
   def solar_array_power_outputs
     Rails.cache.fetch("solar_array_power_outputs", expires_in: 5.minutes) do
       # ... existing query logic ...
     end
   end
   ```

2. **Rule Lookups** (`app/services/asset_processing_service.rb`):
   ```ruby
   def self.trigger_attribute_change_rules(asset, attribute_name, value)
     cache_key = "rules_for_attribute/#{attribute_name}"
     rules = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
       Rule.where(enabled: true)
           .where("when_config->>'condition' = ?", "Asset attribute value changed")
           .where("when_config->>'attribute' = ?", attribute_name)
           .to_a
     end
     # ... rest of logic ...
   end
   ```

3. **Latest Data Points** (`app/services/asset_datapoint_service.rb`):
   ```ruby
   def self.get_latest_datapoint(asset, attribute_name)
     cache_key = "#{asset.cache_key_with_version}/latest_datapoint/#{attribute_name}"
     Rails.cache.fetch(cache_key, expires_in: 1.minute) do
       DataPoint.where(asset: asset, attribute_name: attribute_name)
                .order(timestamp: :desc)
                .first
     end
   end
   ```

### 5. SQL Caching

**Status**: ✅ Automatically enabled by Rails

Rails automatically caches query results within a single request. This is working correctly and requires no configuration.

### 6. Cache Keys

**Status**: ✅ Models use standard Rails conventions

Active Record models automatically generate cache keys based on `id` and `updated_at`. The `cache_key_with_version` method is available for use.

**Recommendation**: When implementing low-level caching, use `cache_key_with_version`:
```ruby
Rails.cache.fetch("#{asset.cache_key_with_version}/competing_price", expires_in: 12.hours) do
  # expensive operation
end
```

### 7. Cache Dependencies

**Status**: ⚠️ Not applicable yet (no fragment caching)

When implementing fragment caching, ensure proper cache invalidation:
- Use `touch: true` on associations if needed for Russian Doll caching
- Consider explicit template dependencies if using helpers

## Recommendations Priority

### High Priority

1. **Uncomment and configure `max_age` in `config/cache.yml`**
   - Set appropriate retention policy (e.g., 60 days)
   - Ensures cache doesn't grow indefinitely

2. **Improve `DocsController` conditional GET**
   - Use `stale?` helper instead of manual Cache-Control
   - Better integration with Rails caching

### Medium Priority

3. **Add low-level caching for expensive queries**
   - Cache `solar_array_power_outputs` results
   - Cache rule lookups in `AssetProcessingService`
   - Cache latest data points with short TTL

4. **Consider fragment caching for collections**
   - Asset listings
   - Rule execution history
   - Any frequently accessed views

### Low Priority

5. **Monitor cache performance**
   - Review cache hit rates
   - Adjust TTLs based on usage patterns
   - Consider cache sharding if scaling horizontally

6. **Document caching strategy**
   - Document which queries/views are cached
   - Document cache TTLs and invalidation strategies

## Implementation Examples

### Example 1: Low-Level Caching for Expensive Query

```ruby
# app/models/asset/querying.rb
def solar_array_power_outputs
  Rails.cache.fetch("solar_array_power_outputs", expires_in: 5.minutes) do
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
end
```

### Example 2: Conditional GET for Static Files

```ruby
# app/controllers/docs_controller.rb
def index
  index_path = Rails.root.join("public", "index.html")
  
  unless File.exist?(index_path)
    redirect_to "/api", status: :found
    return
  end
  
  file_mtime = File.mtime(index_path)
  if stale?(last_modified: file_mtime, public: true, etag: file_mtime.to_i)
    response.headers["Cache-Control"] = "public, max-age=3600"
    render file: index_path, layout: false, content_type: "text/html"
  end
end
```

### Example 3: Fragment Caching for Collections

```erb
<!-- app/views/assets/index.html.erb -->
<%= render partial: "assets/asset", collection: @assets, cached: true %>
```

## Conclusion

The application has a solid caching foundation with Solid Cache properly configured. The main opportunities are:

1. **Immediate**: Configure `max_age` in cache.yml and improve DocsController conditional GET
2. **Short-term**: Add low-level caching for expensive queries
3. **Long-term**: Implement fragment caching for frequently accessed views

All recommendations align with Rails best practices and the Caching with Rails guide.
