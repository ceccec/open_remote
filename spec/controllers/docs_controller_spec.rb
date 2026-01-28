require "rails_helper"

RSpec.describe DocsController, type: :controller do
  describe "GET #index" do
    context "when index.html exists" do
      let(:index_path) { Rails.root.join("public", "index.html") }

      before do
        FileUtils.mkdir_p(File.dirname(index_path))
        File.write(index_path, "<html><body>Docs</body></html>")
      end

      after do
        File.delete(index_path) if File.exist?(index_path)
      end

      it "serves the index.html file" do
        get :index
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Docs")
      end

      context "in production" do
        before do
          allow(Rails.env).to receive(:production?).and_return(true)
        end

        it "sets cache control headers" do
          get :index
          expect(response.headers["Cache-Control"]).to include("public")
          expect(response.headers["Cache-Control"]).to include("max-age=3600")
        end
      end

      context "in non-production" do
        it "does not set cache control headers" do
          get :index
          expect(response.headers["Cache-Control"]).to be_nil
        end
      end
    end

    context "when index.html does not exist" do
      before do
        index_path = Rails.root.join("public", "index.html")
        File.delete(index_path) if File.exist?(index_path)
      end

      it "redirects to /api" do
        get :index
        expect(response).to redirect_to("/api")
        expect(response).to have_http_status(:found)
      end
    end
  end
end
