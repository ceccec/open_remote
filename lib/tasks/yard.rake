##
# YARD documentation generation tasks.
# Links tests to documentation and generates comprehensive API docs.
#
namespace :doc do
  desc "Generate YARD documentation"
  task generate: :environment do
    require "yard"

    puts "Generating YARD documentation..."
    YARD::CLI::CommandParser.run("doc", [ "--no-cache" ])
    puts "Documentation generated in doc/ directory"
  end

  desc "Generate YARD documentation and open in browser"
  task open: :environment do
    require "yard"

    puts "Generating YARD documentation..."
    YARD::CLI::CommandParser.run("doc", [ "--no-cache" ])
    puts "Starting YARD server..."
    system("bundle exec yard server --reload")
  end

  desc "Generate YARD documentation with test links"
  task with_tests: :environment do
    require "yard"

    puts "Generating YARD documentation with test links..."
    YARD::CLI::CommandParser.run("doc", [ "--no-cache" ])
    puts "Documentation generated in doc/ directory"
    puts "Test files are linked via @example tags in source code"
  end

  desc "Clean generated documentation"
  task :clean do
    if Dir.exist?("doc")
      FileUtils.rm_rf("doc")
      puts "Documentation cleaned"
    else
      puts "No documentation directory found"
    end
  end
end

desc "Generate documentation (alias for doc:generate)"
task doc: "doc:generate"
