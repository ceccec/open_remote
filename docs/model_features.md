# Model Features

> **Auto-generated** from model feature declarations.
> To regenerate: `rake docs:features`

This document describes features declared by each model.

**Last Updated**: 2026-01-28 21:26:28

---

# User

## Features

- **Validates** `email`: presence, uniqueness, format
- **Validates** `password`: length
- **Provides methods**: `#admin?`, `#make_admin!`, `#remove_admin!`, `#confirmed?`, `#confirm!`, `#send_confirmation_instructions`, `#remember_me!`, `#forget_me!`, `#remember_token_valid?`, `#send_reset_password_instructions`, `#reset_password`, `#reset_password_period_valid?`, `#access_locked?`, `#lock_access!`, `#unlock_access!`, `#increment_failed_attempts!`, `#send_unlock_instructions`

---

# RuleExecution

## Features

- **Validates** `executed_at`: presence
- **Validates** `status`: presence
- **belongs_to** `rule`
- **Provides methods**: `#rails_admin_label`
- **Provides scopes**: `.successful`, `.failed`, `.skipped`, `.recent`, `.for_rule`, `.with_errors`

---

# Rule

## Features

- **Validates** `name`: presence
- **has_many** `rule_executions` (dependent)
- **Provides methods**: `#when_config_pretty_json`, `#then_config_pretty_json`, `#execute!`
- **Provides scopes**: `.enabled`, `.disabled`, `.with_schedule`, `.scheduled`, `.attribute_value`, `.attribute_changed`, `.recently_executed`, `.with_failed_executions`

---

# Role

## Features

- **Validates** `name`: presence, uniqueness
- **has_and_belongs_to_many** `users`
- **belongs_to** `resource` (polymorphic, optional)
- **Provides methods**: `#find_or_create_by_name`, `#rails_admin_label`

---

# Notification

## Features

- **Validates** `message`: presence
- **Validates** `severity`: presence
- **Validates** `sent_at`: presence
- **belongs_to** `asset` (optional)
- **belongs_to** `rule` (optional)
- **Provides methods**: `#rails_admin_label`
- **Provides scopes**: `.acknowledged`, `.unacknowledged`, `.by_severity`, `.recent`, `.for_asset`, `.for_rule`, `.info`, `.warning`, `.error`

---

# DataPoint

## Features

- **Validates** `attribute_name`: presence
- **Validates** `value`: presence
- **Validates** `timestamp`: presence
- **belongs_to** `asset`
- **Provides methods**: `#rails_admin_label`, `#sum_for`, `#average_for`, `#max_for`, `#min_for`
- **Provides scopes**: `.for_asset`, `.for_attribute`, `.recent`, `.in_time_range`, `.latest_for_attribute`

---

# AssetType

## Features

- **Validates** `name`: presence, uniqueness
- **has_many** `assets` (dependent)
- **Provides methods**: `#rails_admin_label`
- **Provides scopes**: `.with_assets`, `.by_name`

---

# Asset

## Features

- **Validates** `name`: presence
- **belongs_to** `asset_type`
- **belongs_to** `parent` (optional, class_name)
- **has_many** `children` (dependent)
- **has_many** `data_points` (dependent)
- **has_many** `notifications` (dependent)
- **Provides methods**: `#attributes_data_pretty_json`, `#from_openremote_json`, `#to_openremote_json_tree`
- **Provides scopes**: `.root_assets`, `.with_parent`, `.by_type`, `.solar_arrays`, `.solar_parks`, `.of_type`

---

