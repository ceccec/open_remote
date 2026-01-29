##
# Controller to serve VitePress documentation at root.
# Falls back to redirecting to RailsAdmin if docs are not built.
#
class DocsController < ApplicationController
  skip_before_action :authenticate_user!

  ##
  # Serve documentation index or redirect to RailsAdmin.
  # VitePress builds to public/ directory, so we serve index.html from there.
  # Uses conditional GET support for efficient caching.
  #
  def index
    index_path = Rails.root.join("public", "index.html")

    unless File.exist?(index_path)
      # Fallback to RailsAdmin if docs aren't built
      redirect_to "/api", status: :found
      return
    end

    # Use conditional GET for efficient caching
    file_mtime = File.mtime(index_path)

    if Rails.env.production?
      # In production, use stale? with public caching
      if stale?(last_modified: file_mtime, public: true, etag: file_mtime.to_i)
        response.headers["Cache-Control"] = "public, max-age=3600"
        render file: index_path, layout: false, content_type: "text/html"
      end
    else
      # In non-production, render directly without cache headers
      render file: index_path, layout: false, content_type: "text/html"
    end
  end
end
