require "rails"

module OpenRemote
  ##
  # Rails engine wrapper for the full OpenRemote Rails manager.
  #
  # This allows the application to be packaged and distributed as a gem
  # while still running as a standalone Rails app in this repository.
  #
  # In a host app, you can mount the engine with:
  #
  #   mount OpenRemote::Engine => "/openremote"
  #
  class Engine < ::Rails::Engine
    # We intentionally do NOT call `isolate_namespace` yet so that
    # existing top-level controllers/models (ApplicationController, User, etc.)
    # continue to work without renaming. This keeps the engine drop-in
    # compatible with the current app while still being mountable.
  end
end

