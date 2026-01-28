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

    # PostgreSQL configuration for tests
    TEST_DATABASE_NAME = "open_remote_test"
  end
end
