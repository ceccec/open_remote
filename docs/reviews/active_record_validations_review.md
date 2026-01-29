---
title: Active Record Validations Review
lastUpdated: 2026-01-28
---

# Active Record Validations Review

**Date:** January 28, 2026  
**Guide:** [Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html)

## Executive Summary

The application demonstrates **excellent** use of Active Record validations with proper model-level validation, custom validations, conditional validations, and appropriate error handling in controllers. The implementation aligns well with Rails best practices.

**Overall Assessment:** ✅ **Excellent** - Strong validation coverage with minor opportunities for enhancement.

---

## Current Validation Implementation

### 1. Built-in Validations

#### Presence Validations
All models properly validate required fields:

- **User**: `validates :email, presence: true`
- **Asset**: `validates :name, presence: true`
- **DataPoint**: `validates :attribute_name, presence: true`, `validates :value, presence: true`, `validates :timestamp, presence: true`
- **Rule**: `validates :name, presence: true`
- **Notification**: `validates :message, presence: true`, `validates :severity, presence: true`, `validates :sent_at, presence: true`
- **AssetType**: `validates :name, presence: true`
- **RuleExecution**: `validates :executed_at, presence: true`, `validates :status, presence: true`
- **Role**: `validates :name, presence: true`

✅ **Strengths:**
- Consistent use of `presence: true` for required fields
- Proper validation of associations (e.g., `belongs_to :asset` validates presence by default)

#### Uniqueness Validations
- **User**: `validates :email, uniqueness: true` ✅
- **AssetType**: `validates :name, uniqueness: true` ✅
- **Role**: `validates :name, uniqueness: { scope: [ :resource_type, :resource_id ] }` ✅ (scoped uniqueness)

⚠️ **Note:** The guide recommends creating unique database indexes to prevent race conditions. The schema shows unique indexes exist for `users.email` and `asset_types.name`, but we should verify the Role uniqueness constraint.

#### Format Validations
- **User**: `validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }` ✅

✅ **Strengths:**
- Uses standard Rails email regex pattern
- Properly validates email format

#### Length Validations
- **User**: `validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }` ✅

✅ **Strengths:**
- Conditional validation prevents validation on existing records when password isn't being changed
- Appropriate minimum length for passwords

#### Inclusion/Exclusion Validations
- **Role**: `validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true` ✅

✅ **Strengths:**
- Uses `allow_nil: true` for optional polymorphic association
- Validates against dynamic list from Rolify

### 2. Custom Validations

#### Custom Validation Methods
Several models use custom `validate` methods for complex validation logic:

**Asset Model:**
```ruby
validate :attributes_data_presence

private

def attributes_data_presence
  errors.add(:attributes_data, :blank) if attributes_data.nil?
end
```

**Rule Model:**
```ruby
validate :when_config_presence
validate :then_config_presence

private

def when_config_presence
  if when_config.blank?
    errors.add(:when_config, :blank)
  end
end

def then_config_presence
  if then_config.blank?
    errors.add(:then_config, :blank)
  end
end
```

✅ **Strengths:**
- Custom validations properly add errors to the `errors` collection
- Uses `:blank` error type (i18n-friendly)
- Validates JSONB fields that can't use standard `presence` validator

### 3. Conditional Validations

**User Model:**
```ruby
validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
```

✅ **Strengths:**
- Uses lambda for conditional validation
- Prevents validation when password isn't being changed on existing records
- Follows Rails best practices for conditional validations

### 4. Validation Triggers

✅ **Proper Usage:**
- Controllers correctly check `save`/`update` return values
- Uses `render` with `status: :unprocessable_content` when validation fails
- No inappropriate use of `save(validate: false)` in user-facing code

⚠️ **Acceptable Use of `save(validate: false)`:**
- Token generation methods (`generate_reset_password_token!`, `generate_confirmation_token!`, `generate_unlock_token!`) use `save(validate: false)` for internal operations
- This is acceptable as these are internal methods that don't require full validation

### 5. Error Handling in Controllers

**RegistrationsController:**
```ruby
def create
  @user = User.new(user_params)

  if @user.save
    @user.send_confirmation_instructions
    redirect_to main_app.login_path, notice: "Registration successful!"
  else
    render :new, status: :unprocessable_content
  end
end
```

**PasswordsController:**
```ruby
def update
  # ...
  if @user.reset_password(...)
    redirect_to main_app.login_path, notice: "Password has been reset successfully."
  else
    render :edit, status: :unprocessable_content
  end
end
```

✅ **Strengths:**
- Properly checks return values of `save`/`update`
- Renders form with errors when validation fails
- Uses appropriate HTTP status codes

---

## Areas for Enhancement

### 1. Enum-like Fields Could Use Inclusion Validation

**Notification Model:**
```ruby
validates :severity, presence: true
```

**Recommendation:**
```ruby
validates :severity, presence: true, inclusion: { in: %w[info warning error] }
```

This ensures only valid severity levels are accepted and provides better error messages.

**RuleExecution Model:**
```ruby
validates :status, presence: true
```

**Recommendation:**
```ruby
validates :status, presence: true, inclusion: { in: %w[success failed skipped] }
```

### 2. Database Uniqueness Constraints

The guide emphasizes that uniqueness validations should be backed by unique database indexes to prevent race conditions. Let's verify:

✅ **Verified Unique Indexes:**
- `users.email` - unique index exists
- `asset_types.name` - unique index exists
- `roles.name` with scope - composite unique index exists

**Status:** ✅ All uniqueness validations are properly backed by database constraints.

### 3. Password Confirmation Validation

The `User` model doesn't explicitly validate password confirmation, but `has_secure_password` handles this automatically. However, the registration form includes `password_confirmation` in strong parameters, which is correct.

**Status:** ✅ Properly handled via `has_secure_password`.

### 4. Custom Validator Classes

For complex validation logic that might be reused, consider extracting to custom validator classes:

**Example:**
```ruby
class JsonbPresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, :blank)
    end
  end
end

# Usage:
validates :attributes_data, jsonb_presence: true
```

**Status:** ⚠️ **Optional Enhancement** - Current custom validations are fine, but extraction could improve reusability.

### 5. Validation Contexts

The application doesn't currently use custom validation contexts (e.g., `on: :account_setup`). This is fine for the current use case, but could be useful for multi-step forms in the future.

**Status:** ✅ Not needed currently, but good to know for future enhancements.

---

## Validation Best Practices Compliance

### ✅ Model-Level Validations
- All validations are at the model level (not controller-level)
- Follows Rails recommendation for data integrity

### ✅ Proper Error Handling
- Controllers check validation results
- Errors are properly displayed to users
- Appropriate HTTP status codes used

### ✅ Conditional Validations
- Uses `:if` option appropriately
- Prevents unnecessary validations

### ✅ Custom Validations
- Properly implemented using `validate` method
- Errors added to `errors` collection correctly

### ✅ Database Constraints
- Unique indexes back uniqueness validations
- Foreign key constraints ensure referential integrity

### ✅ Validation Triggers
- Uses `save`/`update` (not `save!`/`update!`) in controllers
- Properly handles validation failures

---

## Recommendations

### High Priority
1. **Add inclusion validations for enum-like fields:**
   - `Notification.severity` → `inclusion: { in: %w[info warning error] }`
   - `RuleExecution.status` → `inclusion: { in: %w[success failed skipped] }`

### Medium Priority
2. **Consider extracting reusable validators:**
   - Create `JsonbPresenceValidator` for JSONB field validation
   - Could be reused across models

### Low Priority
3. **Document validation behavior:**
   - Add comments explaining why certain validations are conditional
   - Document any business rules enforced by validations

---

## Conclusion

The application demonstrates **excellent** validation practices:

✅ **Strengths:**
- Comprehensive presence validations
- Proper uniqueness validations with database constraints
- Custom validations for complex fields (JSONB)
- Conditional validations where appropriate
- Proper error handling in controllers
- No inappropriate use of validation-skipping methods

⚠️ **Minor Enhancements:**
- Add inclusion validations for enum-like fields
- Consider extracting reusable validators for JSONB validation

**Overall:** The validation implementation aligns well with Rails best practices and the Active Record Validations guide. The suggested enhancements are minor and would improve type safety and error messages.

---

## Implementation Notes

### Adding Inclusion Validations

**Notification Model:**
```ruby
validates :severity, presence: true, inclusion: { in: %w[info warning error] }
```

**RuleExecution Model:**
```ruby
validates :status, presence: true, inclusion: { in: %w[success failed skipped] }
```

These changes ensure only valid values are accepted and provide clearer error messages when invalid values are provided.
