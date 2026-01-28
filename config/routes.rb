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

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Serve VitePress documentation at root
  # VitePress builds to public/ directory
  # If docs are built, serve them; otherwise redirect to RailsAdmin
  root "docs#index"
end
