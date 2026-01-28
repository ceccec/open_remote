##
# Controller to serve VitePress documentation at root.
# Falls back to redirecting to RailsAdmin if docs are not built.
#
class DocsController < ApplicationController
  skip_before_action :authenticate_user!

  ##
  # Serve documentation index or redirect to RailsAdmin.
  # VitePress builds to public/ directory, so we serve index.html from there.
  #
  def index
    index_path = Rails.root.join("public", "index.html")
    
    if File.exist?(index_path)
      # Serve the VitePress-generated index.html
      # Set proper headers for SPA routing
      response.headers["Cache-Control"] = "public, max-age=3600" if Rails.env.production?
      render file: index_path, layout: false, content_type: "text/html"
    else
      # Fallback to RailsAdmin if docs aren't built
      redirect_to "/api", status: :found
    end
  end
end
