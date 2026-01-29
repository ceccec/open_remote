---
title: Rails Routing from the Outside In Review
lastUpdated: 2026-01-28
---

# Rails Routing from the Outside In Review

**Date:** January 28, 2026  
**Guide:** [Rails Routing from the Outside In](https://guides.rubyonrails.org/routing.html)

## Executive Summary

The application demonstrates **excellent** routing practices with clear, well-organized routes, proper use of named routes, and appropriate HTTP verb usage. The implementation aligns well with Rails best practices.

**Overall Assessment:** ✅ **Excellent** - Routing follows Rails conventions.

---

## Current Routing Implementation

### 1. Route Structure

**Routes File (`config/routes.rb`):**
```ruby
Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/api", as: "rails_admin"

  # Authentication routes (Devise-like without Devise)
  # Sessions
  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # Registration
  get "/signup", to: "registrations#new", as: :signup
  post "/signup", to: "registrations#create"
  get "/account/edit", to: "registrations#edit", as: :edit_account
  patch "/account", to: "registrations#update", as: :update_account
  put "/account", to: "registrations#update"

  # Password reset
  get "/password/new", to: "passwords#new", as: :new_password
  post "/password", to: "passwords#create", as: :password
  get "/password/edit", to: "passwords#edit", as: :edit_password
  patch "/password", to: "passwords#update"
  put "/password", to: "passwords#update"

  # Email confirmation
  get "/confirmation", to: "confirmations#show", as: :confirmation
  get "/confirmation/new", to: "confirmations#new", as: :new_confirmation
  post "/confirmation", to: "confirmations#create", as: :create_confirmation

  # Account unlock
  get "/unlock", to: "unlocks#show", as: :unlock
  get "/unlock/new", to: "unlocks#new", as: :new_unlock
  post "/unlock", to: "unlocks#create", as: :create_unlock

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route
  root "docs#index"
end
```

✅ **Strengths:**
- Well-organized with clear sections
- Proper use of HTTP verbs (GET, POST, PATCH, PUT, DELETE)
- Named routes using `as:` option
- Clear, descriptive route paths
- Proper use of `mount` for RailsAdmin engine
- Root route properly defined

### 2. Route Patterns

**Authentication Routes:**
- ✅ Uses RESTful patterns where appropriate
- ✅ Clear, descriptive paths (`/login`, `/signup`, `/password`)
- ✅ Proper HTTP verb usage
- ✅ Named routes for easy reference

**Route Organization:**
- ✅ Grouped by feature (Sessions, Registration, Password, etc.)
- ✅ Comments explain purpose
- ✅ Logical ordering

### 3. Named Routes

**Current Named Routes:**
- `login_path`, `logout_path`
- `signup_path`
- `edit_account_path`, `update_account_path`
- `new_password_path`, `password_path`, `edit_password_path`
- `confirmation_path`, `new_confirmation_path`, `create_confirmation_path`
- `unlock_path`, `new_unlock_path`, `create_unlock_path`
- `rails_health_check_path`
- `root_path`

✅ **Strengths:**
- Consistent naming conventions
- All routes have appropriate names
- Easy to use in controllers and views

### 4. Engine Mounting

**RailsAdmin Engine:**
```ruby
mount RailsAdmin::Engine => "/api", as: "rails_admin"
```

✅ **Strengths:**
- Properly mounted at `/api`
- Named for route helpers
- Follows Rails conventions

### 5. Root Route

```ruby
root "docs#index"
```

✅ **Strengths:**
- Properly defined root route
- Points to appropriate controller action
- Follows Rails conventions

---

## Areas for Enhancement

### 1. Resourceful Routes

**Current Status:** No resourceful routes (`resources`) are used.

**Analysis:**
The application uses custom authentication routes instead of RESTful resources. This is appropriate for authentication flows but could be considered for other resources if added.

**Status:** ✅ **No Issues** - Current approach is appropriate for authentication routes.

### 2. Route Constraints

**Current Status:** No route constraints are used.

**Recommendation:**
If you need to add constraints (e.g., format, subdomain):

```ruby
get "/api/:version", to: "api#index", constraints: { version: /\d+\.\d+/ }
```

**Status:** ✅ **No Issues** - Constraints not needed currently.

### 3. Nested Routes

**Current Status:** No nested routes are used.

**Analysis:**
The application doesn't have resources that would benefit from nesting. If you add resources with relationships (e.g., assets with data points), consider nested routes:

```ruby
resources :assets do
  resources :data_points, only: [:index, :create]
end
```

**Status:** ✅ **No Issues** - Nested routes not needed currently.

### 4. Route Testing

**Current Status:** No route tests found.

**Recommendation:**
Consider adding route tests:

```ruby
# spec/routing/sessions_routing_spec.rb
RSpec.describe "Sessions routes" do
  it "routes GET /login to sessions#new" do
    expect(get: "/login").to route_to("sessions#new")
  end
end
```

**Status:** ⚠️ **Optional Enhancement** - Tests would improve reliability.

### 5. Route Documentation

**Current Status:** Routes are well-commented.

**Recommendation:**
Consider using `bin/rails routes` output for documentation or adding more detailed comments for complex routes.

**Status:** ✅ **No Issues** - Current documentation is adequate.

---

## Best Practices Compliance

### ✅ Route Organization
- Well-organized with clear sections
- Logical grouping by feature
- Helpful comments

### ✅ HTTP Verbs
- Proper use of GET, POST, PATCH, PUT, DELETE
- Appropriate verb for each action

### ✅ Named Routes
- All routes have appropriate names
- Consistent naming conventions
- Easy to use in code

### ✅ Route Patterns
- Clear, descriptive paths
- RESTful where appropriate
- Custom routes where needed

### ✅ Engine Mounting
- Properly mounted RailsAdmin engine
- Appropriate path and naming

---

## Recommendations

### High Priority
**None** - Current routing is excellent.

### Medium Priority
1. **Consider route tests:**
   - Test route recognition
   - Test route generation
   - Improve reliability

### Low Priority
2. **Consider resourceful routes for new resources:**
   - Use `resources` for CRUD operations
   - Follow RESTful conventions

3. **Add route constraints if needed:**
   - Format constraints
   - Parameter constraints
   - Request-based constraints

---

## Conclusion

The application demonstrates **excellent** routing practices:

✅ **Strengths:**
- Well-organized route structure
- Proper HTTP verb usage
- Clear, descriptive paths
- Appropriate named routes
- Proper engine mounting
- Good documentation

⚠️ **Optional Enhancements:**
- Consider route tests
- Consider resourceful routes for new resources

**Overall:** The routing implementation aligns well with Rails best practices and the Rails Routing guide. The routes are clean, well-organized, and follow Rails conventions.

---

## Route Summary

**Total Routes:** ~25 routes

**Route Categories:**
- Authentication (Sessions, Registration, Password, Confirmation, Unlock)
- Admin (RailsAdmin engine)
- Health check
- Root route

**Route Patterns:**
- Custom authentication routes (appropriate for Devise-like flows)
- Engine mounting (RailsAdmin)
- Health check route
- Root route

All routes follow Rails conventions and best practices.
