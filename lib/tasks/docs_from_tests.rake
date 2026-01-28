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
  task dev: :from_tests do
    puts "\nStarting VitePress dev server..."
    Dir.chdir(Rails.root.join("docs")) do
      system("npx vitepress dev")
    end
  end

  desc "Build VitePress documentation for production (outputs to public/)"
  task build: :from_tests do
    puts "\nBuilding VitePress documentation to public/..."
    Dir.chdir(Rails.root.join("docs")) do
      system("npx vitepress build")
    end
    puts "✅ Documentation built to public/ directory"
    puts "   Access at: http://localhost:3000/"
  end
end
