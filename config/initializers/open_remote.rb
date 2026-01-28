##
# OpenRemote application configuration
# Centralized configuration for versions, paths, and shared application settings
#
module OpenRemote
  module Config
    # Application metadata
    APP_NAME = "OpenRemote Rails API"
    APP_DESCRIPTION = "API documentation auto-generated from Rails components and test examples"

    # VitePress configuration
    VITEPRESS_VERSION = "alpha" # Use 'alpha' for latest alpha, or specific version like '^1.6.0'

    # Vite version (must be compatible with VitePress)
    VITE_VERSION = "^7.0.0" # Use Vite 7 for latest features
    VITEPRESS_BASE_PATH = if ENV["GITHUB_REPOSITORY"]
      repo_name = ENV["GITHUB_REPOSITORY"].split("/").last
      "/#{repo_name}/"
    else
      "/"
    end

    # VitePress output directory configuration
    # - For GitHub Pages: .vitepress/dist (relative to docs/)
    # - For local development: ../public (relative to docs/)
    VITEPRESS_OUT_DIR = if ENV["GITHUB_ACTIONS"] == "true"
      ".vitepress/dist"
    else
      "../public"
    end

    # VitePress cache directory (relative to docs/)
    VITEPRESS_CACHE_DIR = ".vitepress/cache"

    # VitePress language/locale
    VITEPRESS_LANG = "en-US"

    # Enable last updated timestamps (uses Git)
    VITEPRESS_LAST_UPDATED = true

    # Dark mode appearance: true (auto), false (disabled), 'dark' (default dark), 'force-dark', 'force-auto'
    VITEPRESS_APPEARANCE = true

    # Ignore dead links during build (can be true, 'localhostLinks', or array of patterns)
    VITEPRESS_IGNORE_DEAD_LINKS = false

    # Documentation paths
    DOCS_DIR = Rails.root.join("docs")
    DOCS_API_DIR = DOCS_DIR.join("api")
    DOCS_EXAMPLES_DIR = DOCS_DIR.join("examples")
    DOCS_VITEPRESS_CONFIG_DIR = DOCS_DIR.join(".vitepress")

    # Temporary file directories (all ignored via .gitignore)
    TMP_VITEPRESS_CACHE_DIR = Rails.root.join("tmp", "vitepress-cache")
    TMP_RUBOCOP_DIR = Rails.root.join("tmp", "rubocop")

    # GitHub Pages configuration
    GITHUB_PAGES_BASE_PATH = "/open_remote/" # Update if repository name changes

    # Node.js version for CI/CD
    NODE_VERSION = "20"

    # Package manager (npm only - yarn.lock is ignored)
    PACKAGE_MANAGER = "npm"

    # PostgreSQL configuration for tests
    TEST_DATABASE_NAME = "open_remote_test"
  end
end
