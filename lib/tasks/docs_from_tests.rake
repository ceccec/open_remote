##
# Rake task to generate VitePress-style documentation from test results.
# Extracts examples from RSpec tests and creates comprehensive documentation.
#
namespace :docs do
  desc "Generate VitePress documentation from test examples"
  task from_tests: :environment do
    require_relative "../tasks/docs_generator"

    puts "=" * 80
    puts "Generating VitePress documentation from test examples..."
    puts "=" * 80

    generator = DocsGenerator.new
    generator.generate

    puts "\n✅ Documentation generated in docs/ directory"
    puts "📚 View documentation: npm run docs:dev"
    puts "=" * 80
  end

  desc "Generate documentation and run VitePress dev server"
  task dev: :environment do
    Rake::Task["docs:from_tests"].invoke
    puts "\nStarting VitePress dev server..."
    Dir.chdir(OpenRemote::Config::DOCS_DIR) do
      system("npm run dev")
    end
  end

  desc "Build VitePress documentation for production (outputs to public/)"
  task build: :environment do
    Rake::Task["docs:from_tests"].invoke
    puts "\nBuilding VitePress documentation..."
    Dir.chdir(OpenRemote::Config::DOCS_DIR) do
      # Use npm run to ensure we use the local node_modules with VitePress alpha
      system("npm run build")
    end
    puts "✅ Documentation built to #{OpenRemote::Config::VITEPRESS_OUT_DIR}"
    puts "   Access at: http://localhost:3000/"
  end
end
