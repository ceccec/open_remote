---
name: Canonical RailsAdmin Configuration
overview: "Configure RailsAdmin following Rails and RailsAdmin best practices: explicitly include all ApplicationRecord models, configure JSONB fields with proper labels and pretty-printing, set up navigation groups, and ensure proper field visibility and object labeling."
todos: []
isProject: false
---

# Canonical RailsAdmin Configuration

## Current State Analysis

The current `config/initializers/rails_admin.rb` has:

- Basic authentication (`require_admin!`)
- Authorization (CanCanCan)
- Auditing (PaperTrail)
- Standard actions enabled
- **Missing**: Explicit model inclusion, JSONB field configuration, navigation groups, field visibility

## Models to Include

Based on the schema and ApplicationRecord inheritance, include these models:

- `User` - Admin user management
- `AssetType` - Asset type definitions
- `Asset` - Assets with JSONB `attributes_data`
- `DataPoint` - Time-series data with JSONB `value`
- `Rule` - Rules with JSONB `when_config` and `then_config`
- `RuleExecution` - Rule execution history with JSONB `result`
- `Notification` - System notifications

**Exclude** (not ApplicationRecord):

- `Ability` (CanCanCan ability class)
- `UniqueIdentifierGenerator` (utility class)
- `ValueUtil` (utility class)
- All concern modules

## Implementation Steps

### 1. Add Explicit Model Inclusion

Add `config.included_models` with an allowlist of all ApplicationRecord models. This follows the canonical allowlist approach recommended by RailsAdmin.

### 2. Configure JSONB Fields

For models with JSONB columns, configure fields to:

- Use pretty-printed JSON display (leveraging existing `*_pretty_json` methods)
- Show as read-only text areas in forms
- Include proper labels

**Models needing JSONB configuration:**

- `Asset`: `attributes_data` → use `attributes_data_pretty_json` method
- `DataPoint`: `value` → format as JSON
- `Rule`: `when_config` → use `when_config_pretty_json`, `then_config` → use `then_config_pretty_json`
- `RuleExecution`: `result` → format as JSON

### 3. Set Up Navigation Groups

Organize models into logical groups:

- **Users & Access**: User
- **Assets**: AssetType, Asset
- **Data**: DataPoint
- **Rules**: Rule, RuleExecution
- **System**: Notification

### 4. Configure Object Labeling

Set `label_methods` to use meaningful display names:

- `User`: `email`
- `Asset`: `name`
- `AssetType`: `display_name` or `name`
- `Rule`: `name`
- `DataPoint`: composite label (asset name + attribute + timestamp)
- `RuleExecution`: composite label (rule name + status + executed_at)
- `Notification`: `message` or composite

### 5. Field Visibility and Organization

For each model, configure:

- **Show fields**: All relevant fields, with JSONB fields formatted
- **List fields**: Key identifying fields (name, email, status, timestamps)
- **Edit fields**: Editable fields only, excluding audit fields (`created_at`, `updated_at`)
- **Group fields**: Logical grouping (e.g., "Basic Info", "Configuration", "Relationships", "Audit")

### 6. Association Display

Configure associations to show meaningful labels:

- `Asset.belongs_to :asset_type` → show asset type name
- `Asset.belongs_to :parent` → show parent asset name
- `DataPoint.belongs_to :asset` → show asset name
- `RuleExecution.belongs_to :rule` → show rule name
- `Notification.belongs_to :asset` and `:rule` → show names

## File Changes

### `config/initializers/rails_admin.rb`

Expand the configuration to include:

```ruby
RailsAdmin.config do |config|
  config.asset_source = :vite
  config.main_app_name = ["OpenRemote", "Admin"]
  
  # Authentication & current user
  config.authenticate_with do
    require_admin!
  end
  config.current_user_method(&:current_user)
  
  # Authorization via CanCanCan
  config.authorize_with :cancancan
  
  # Auditing via PaperTrail
  config.audit_with :paper_trail, "User", "PaperTrail::Version"
  
  # Explicit model inclusion (allowlist approach)
  config.included_models = [
    "User",
    "AssetType",
    "Asset",
    "DataPoint",
    "Rule",
    "RuleExecution",
    "Notification"
  ]
  
  # Object labeling
  config.label_methods << :display_name
  config.label_methods << :email
  
  # Model-specific configurations
  config.model "User" do
    list do
      field :email
      field :admin
      field :created_at
      field :updated_at
    end
    
    edit do
      field :email
      field :password
      field :admin
    end
    
    show do
      field :id
      field :email
      field :admin
      field :created_at
      field :updated_at
    end
  end
  
  config.model "AssetType" do
    list do
      field :name
      field :display_name
      field :description
      field :created_at
    end
    
    edit do
      group :basic_info do
        field :name
        field :display_name
        field :description
        field :icon
      end
    end
  end
  
  config.model "Asset" do
    list do
      field :name
      field :asset_type
      field :parent
      field :created_at
    end
    
    edit do
      group :basic_info do
        field :name
        field :asset_type
        field :parent
      end
      
      group :attributes do
        field :attributes_data, :json do
          formatted_value do
            bindings[:object].attributes_data_pretty_json
          end
        end
      end
    end
    
    show do
      group :basic_info do
        field :id
        field :name
        field :asset_type
        field :parent
        field :children
      end
      
      group :attributes do
        field :attributes_data, :json do
          formatted_value do
            bindings[:object].attributes_data_pretty_json
          end
        end
      end
      
      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end
  
  config.model "DataPoint" do
    list do
      field :asset
      field :attribute_name
      field :timestamp
      field :value
    end
    
    show do
      group :basic_info do
        field :id
        field :asset
        field :attribute_name
        field :timestamp
      end
      
      group :value do
        field :value, :json
      end
      
      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end
  
  config.model "Rule" do
    list do
      field :name
      field :enabled
      field :created_at
    end
    
    edit do
      group :basic_info do
        field :name
        field :description
        field :enabled
        field :schedule
        field :timezone
      end
      
      group :configuration do
        field :when_config, :json do
          formatted_value do
            bindings[:object].when_config_pretty_json
          end
        end
        field :then_config, :json do
          formatted_value do
            bindings[:object].then_config_pretty_json
          end
        end
      end
    end
    
    show do
      group :basic_info do
        field :id
        field :name
        field :description
        field :enabled
        field :schedule
        field :timezone
      end
      
      group :configuration do
        field :when_config, :json do
          formatted_value do
            bindings[:object].when_config_pretty_json
          end
        end
        field :then_config, :json do
          formatted_value do
            bindings[:object].then_config_pretty_json
          end
        end
      end
      
      group :executions do
        field :rule_executions
      end
      
      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end
  
  config.model "RuleExecution" do
    list do
      field :rule
      field :status
      field :executed_at
      field :error_message
    end
    
    show do
      group :basic_info do
        field :id
        field :rule
        field :status
        field :executed_at
        field :error_message
      end
      
      group :result do
        field :result, :json
      end
      
      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end
  
  config.model "Notification" do
    list do
      field :message
      field :severity
      field :sent_at
      field :acknowledged_at
      field :asset
      field :rule
    end
    
    show do
      group :basic_info do
        field :id
        field :message
        field :severity
        field :sent_at
        field :acknowledged_at
      end
      
      group :associations do
        field :asset
        field :rule
      end
      
      group :audit do
        field :created_at
        field :updated_at
      end
    end
  end
  
  # Navigation groups
  config.navigation_static_links = {
    "OpenRemote Docs" => "https://github.com/openremote/openremote"
  }
  
  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
end
```

## Testing

After implementation:

1. Verify all models appear in RailsAdmin navigation
2. Test JSONB field display (should show pretty-printed JSON)
3. Verify field groups render correctly
4. Test CRUD operations for each model
5. Ensure PaperTrail auditing works (check versions table)
6. Verify CanCanCan authorization (non-admins should be blocked)

## Notes

- JSONB fields use `:json` type with custom `formatted_value` blocks to leverage existing `*_pretty_json` methods
- Navigation groups will be automatically created based on model associations
- All models use UUID primary keys (configured in `config/application.rb`)
- Audit fields (`created_at`, `updated_at`) are shown in "Audit" groups but excluded from edit forms

