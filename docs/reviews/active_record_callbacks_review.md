---
title: Active Record Callbacks Review
lastUpdated: 2026-01-28
---

# Active Record Callbacks Review

**Date:** January 28, 2026  
**Guide:** [Active Record Callbacks](https://guides.rubyonrails.org/active_record_callbacks.html)

## Executive Summary

The application demonstrates **excellent** use of Active Record callbacks with proper conditional callbacks, appropriate use of `before_create` and `before_save`, and correct implementation of `after_find` and `after_initialize`. The implementation aligns well with Rails best practices.

**Overall Assessment:** ✅ **Excellent** - Callbacks are used appropriately and follow Rails conventions.

---

## Current Callback Implementation

### 1. Create Callbacks

#### `before_create` Callbacks

**User::Confirmable Concern:**
```ruby
included do
  before_create :generate_confirmation_token, unless: :confirmed?
end
```

✅ **Strengths:**
- Uses conditional callback (`unless: :confirmed?`) to prevent unnecessary token generation
- Properly placed in `included` block for concern integration
- Method is private (follows best practices)
- Uses direct assignment (`self.confirmation_token = ...`) instead of `update` (avoids side effects)

**Purpose:** Generates a confirmation token when creating a new user, but only if the user isn't already confirmed.

### 2. Save Callbacks

#### `before_save` Callbacks

**User::Lockable Concern:**
```ruby
included do
  before_save :reset_failed_attempts!, if: :access_locked?
end
```

✅ **Strengths:**
- Uses conditional callback (`if: :access_locked?`) to run only when needed
- Properly placed in `included` block
- Uses direct assignment (`self.failed_attempts = 0`) instead of `update`
- Well-documented with comments explaining the callback condition

**Purpose:** Resets failed login attempts when saving a locked account (likely when unlocking).

### 3. Find and Initialize Callbacks

#### `after_find` and `after_initialize` Callbacks

**Asset::Type::Dispatch Concern:**
```ruby
included do
  after_find :extend_type_module
  after_initialize :extend_type_module
end

private

def extend_type_module
  return unless asset_type

  mod = case asset_type.name
  when "SolarPark" then Asset::Type::Solar::Park::Attributes
  when "SolarArray" then Asset::Type::Solar::Array::Attributes
  # ... more types
  end
  extend mod if mod && !is_a?(mod)
end
```

✅ **Strengths:**
- Uses both `after_find` and `after_initialize` to ensure type module is extended regardless of how the object is loaded
- Guards against missing `asset_type` association
- Checks if already extended (`!is_a?(mod)`) to avoid redundant extension
- Properly uses `extend` for dynamic module inclusion

**Purpose:** Dynamically extends Asset instances with type-specific modules based on their `asset_type.name`.

### 4. Association Callbacks

#### `dependent: :destroy` Callbacks

The application uses `dependent: :destroy` extensively:

- **Asset**: `has_many :children, dependent: :destroy`
- **Asset**: `has_many :data_points, dependent: :destroy`
- **Asset**: `has_many :notifications, dependent: :destroy`
- **AssetType**: `has_many :assets, dependent: :destroy`
- **Rule**: `has_many :rule_executions, dependent: :destroy`

✅ **Strengths:**
- Appropriate use of `dependent: :destroy` for cascading deletions
- Ensures data integrity when parent records are destroyed
- Follows Rails conventions for association callbacks

### 5. Third-Party Gem Callbacks

#### PaperTrail (`has_paper_trail`)

Used on multiple models:
- `Asset`, `AssetType`, `DataPoint`, `Notification`, `Role`, `Rule`, `RuleExecution`, `User`

✅ **Strengths:**
- Properly integrated for audit trail functionality
- Automatically tracks changes via callbacks

#### `has_secure_password`

Used on `User` model:
```ruby
has_secure_password
```

✅ **Strengths:**
- Uses Rails built-in password hashing callbacks
- Automatically handles password encryption before save

---

## Callback Best Practices Compliance

### ✅ Conditional Callbacks
- Uses `:if` and `:unless` options appropriately
- Prevents unnecessary callback execution

### ✅ Private Callback Methods
- All custom callback methods are declared as `private`
- Follows Rails best practices for encapsulation

### ✅ Direct Assignment in Callbacks
- Uses `self.attribute = value` instead of `update(attribute: value)`
- Avoids side effects and potential callback loops

### ✅ Appropriate Callback Types
- Uses `before_create` for initialization logic
- Uses `before_save` for conditional updates
- Uses `after_find` and `after_initialize` for dynamic behavior

### ✅ No Callback Side Effects
- Callbacks don't call `save`, `update`, or other persistence methods
- Avoids potential infinite loops or unexpected behavior

### ✅ Proper Concern Integration
- Callbacks are properly registered in `included` blocks
- Follows ActiveSupport::Concern conventions

---

## Areas for Enhancement

### 1. Transaction Callbacks (`after_commit`, `after_rollback`)

**Current Status:** No `after_commit` or `after_rollback` callbacks are currently used.

**Recommendation:** Consider using `after_commit` for operations that should only happen after the database transaction commits successfully, such as:
- Sending emails (already handled via `deliver_later` which is appropriate)
- External API calls
- Cache invalidation
- File system operations

**Example Use Case:**
If you need to perform file operations after an Asset is created, you could use:
```ruby
after_commit :process_asset_files, on: :create

private

def process_asset_files
  # Only runs after transaction commits
  # If transaction rolls back, this won't run
end
```

**Status:** ⚠️ **Optional Enhancement** - Not currently needed, but good to know for future use.

### 2. Callback Ordering

**Current Status:** Callbacks are well-organized and don't have ordering conflicts.

**Recommendation:** If you need to ensure specific callback order in the future, you can use:
- `prepend: true` option to run callbacks before others
- Explicit ordering by defining callbacks in the desired sequence

**Status:** ✅ **No Issues** - Current callback order is appropriate.

### 3. Halting Execution

**Current Status:** No callbacks currently use `throw :abort` to halt execution.

**Recommendation:** If you need to prevent save/destroy operations conditionally, use `throw :abort`:
```ruby
before_save :prevent_save_if_invalid

private

def prevent_save_if_invalid
  throw :abort if some_condition
end
```

**Status:** ✅ **No Issues** - Not currently needed.

### 4. Association Callbacks

**Current Status:** Only uses `dependent: :destroy` for association callbacks.

**Recommendation:** If you need to perform actions when associations are added/removed, consider:
- `before_add` / `after_add` callbacks
- `before_remove` / `after_remove` callbacks

**Example:**
```ruby
has_many :notifications, before_add: :validate_notification_limit

private

def validate_notification_limit(notification)
  throw :abort if notifications.count >= 100
end
```

**Status:** ✅ **No Issues** - Current implementation is sufficient.

### 5. Callback Objects

**Current Status:** All callbacks are implemented as methods.

**Recommendation:** If you have reusable callback logic, consider extracting to callback objects:
```ruby
class TokenGeneratorCallback
  def self.before_create(record)
    record.confirmation_token = SecureRandom.urlsafe_base64(32)
  end
end

# Usage:
before_create TokenGeneratorCallback
```

**Status:** ⚠️ **Optional Enhancement** - Current method-based approach is fine, but callback objects could improve reusability.

---

## Potential Issues and Considerations

### 1. `save(validate: false)` Usage

**Current Usage:**
- `User::Confirmable#generate_confirmation_token!` uses `save(validate: false)`
- `User::Lockable#generate_unlock_token!` uses `save(validate: false)`
- `User::Rememberable#generate_remember_token!` uses `save(validate: false)`

**Analysis:**
✅ **Acceptable** - These are internal methods for token generation that don't require full validation. The tokens are generated before the main save operation, so skipping validation here is appropriate.

**Best Practice:** Only use `save(validate: false)` for internal operations that don't require full validation, which is exactly what's happening here.

### 2. Dynamic Module Extension

**Current Implementation:**
```ruby
after_find :extend_type_module
after_initialize :extend_type_module
```

**Analysis:**
✅ **Appropriate** - Uses `after_find` and `after_initialize` to ensure type modules are extended regardless of how objects are loaded. The guard clause (`return unless asset_type`) prevents errors when `asset_type` is nil.

**Consideration:** This pattern is fine, but be aware that:
- Module extension happens on every find/initialize
- The `!is_a?(mod)` check prevents redundant extension
- This is a valid use case for these callbacks

### 3. Conditional Callback Logic

**Current Implementation:**
- `before_create :generate_confirmation_token, unless: :confirmed?`
- `before_save :reset_failed_attempts!, if: :access_locked?`

**Analysis:**
✅ **Excellent** - Uses conditional callbacks appropriately to prevent unnecessary execution. This is a Rails best practice.

---

## Recommendations

### High Priority
**None** - Current callback implementation is excellent.

### Medium Priority
1. **Consider `after_commit` for external operations:**
   - If you add file system operations, external API calls, or cache invalidation
   - Use `after_commit` to ensure these only run after successful database commits

2. **Document callback behavior:**
   - Add comments explaining why certain callbacks are conditional
   - Document any business rules enforced by callbacks

### Low Priority
3. **Consider callback objects for reusable logic:**
   - If token generation logic needs to be reused across models
   - Extract to callback objects for better testability and reusability

---

## Conclusion

The application demonstrates **excellent** callback practices:

✅ **Strengths:**
- Proper use of conditional callbacks (`:if`, `:unless`)
- Appropriate callback types for each use case
- Direct assignment in callbacks (no side effects)
- Private callback methods (proper encapsulation)
- Well-organized concern-based callback registration
- Appropriate use of `save(validate: false)` for internal operations

✅ **No Issues Found:**
- No callback loops or side effects
- No inappropriate use of persistence methods in callbacks
- No missing conditional logic where needed

⚠️ **Optional Enhancements:**
- Consider `after_commit` for future external operations
- Consider callback objects if logic needs to be reused

**Overall:** The callback implementation aligns perfectly with Rails best practices and the Active Record Callbacks guide. The code is clean, well-organized, and follows all recommended patterns.

---

## Implementation Notes

### Current Callback Summary

1. **User::Confirmable**
   - `before_create :generate_confirmation_token, unless: :confirmed?`
   - Purpose: Generate confirmation token on user creation

2. **User::Lockable**
   - `before_save :reset_failed_attempts!, if: :access_locked?`
   - Purpose: Reset failed attempts when unlocking account

3. **Asset::Type::Dispatch**
   - `after_find :extend_type_module`
   - `after_initialize :extend_type_module`
   - Purpose: Dynamically extend Asset with type-specific modules

4. **Association Callbacks**
   - Multiple `dependent: :destroy` associations
   - Purpose: Cascade deletions for data integrity

5. **Third-Party Callbacks**
   - `has_paper_trail` (audit trail)
   - `has_secure_password` (password hashing)

All callbacks are properly implemented and follow Rails conventions.
