require "rails_helper"
require_relative "../../../lib/tasks/docs_generator"

RSpec.describe DocsGenerator do
  let(:generator) { described_class.new }

  describe "#extract_class_name_from_file" do
    it "infers controller class name from file path" do
      content = "class SomeController"
      file_path = Rails.root.join("app/controllers/some_controller.rb")
      result = generator.send(:extract_class_name_from_file, content, file_path.to_s, :controllers, [])
      expect(result).to eq("SomeController")
    end

    it "infers model class name without namespace" do
      content = "class User"
      file_path = Rails.root.join("app/models/user.rb")
      result = generator.send(:extract_class_name_from_file, content, file_path.to_s, :models, [])
      expect(result).to eq("User")
    end

    it "infers model class name with namespace" do
      content = "class Asset"
      file_path = Rails.root.join("app/models/asset/querying.rb")
      namespace = ["asset"]
      result = generator.send(:extract_class_name_from_file, content, file_path.to_s, :models, namespace)
      expect(result).to eq("Asset::Querying")
    end

    it "infers service class name" do
      content = "class SomeService"
      file_path = Rails.root.join("app/services/some_service.rb")
      result = generator.send(:extract_class_name_from_file, content, file_path.to_s, :services, [])
      expect(result).to eq("SomeService")
    end

    it "infers job class name" do
      content = "class SomeJob"
      file_path = Rails.root.join("app/jobs/some_job.rb")
      result = generator.send(:extract_class_name_from_file, content, file_path.to_s, :jobs, [])
      expect(result).to eq("SomeJob")
    end

    it "infers concern class name with namespace" do
      content = "module SomeConcern"
      file_path = Rails.root.join("app/models/concerns/user/confirmable.rb")
      namespace = ["user"]
      result = generator.send(:extract_class_name_from_file, content, file_path.to_s, :concerns, namespace)
      expect(result).to eq("User::Confirmable")
    end

    it "falls back to camelize for unknown types" do
      content = "class Unknown"
      file_path = Rails.root.join("app/unknown/unknown.rb")
      result = generator.send(:extract_class_name_from_file, content, file_path.to_s, :unknown, [])
      expect(result).to eq("Unknown")
    end
  end

  describe "#extract_class_description" do
    it "returns default when file doesn't exist" do
      result = generator.send(:extract_class_description, "NonExistentClass")
      expect(result).to eq("API documentation for NonExistentClass")
    end

    it "returns default when file has no ## comment" do
      # Create a temporary file without ## comment
      temp_file = Rails.root.join("tmp/test_class.rb")
      File.write(temp_file, "class TestClass\nend")
      begin
        allow(Rails.root).to receive(:join).and_call_original
        allow(Rails.root).to receive(:join).with("app", "models", "test_class.rb").and_return(temp_file)
        allow(Rails.root).to receive(:join).with("app", "services", "test_class.rb").and_return(temp_file)
        allow(Rails.root).to receive(:join).with("app", "controllers", "test_class_controller.rb").and_return(temp_file)
        result = generator.send(:extract_class_description, "TestClass")
        expect(result).to eq("API documentation for TestClass")
      ensure
        File.delete(temp_file) if File.exist?(temp_file)
      end
    end
  end

  describe "#generate_component_doc" do
    it "truncates methods list when exceeding MAX_METHODS_PER_COMPONENT" do
      component = {
        class_name: "TestClass",
        description: "Test",
        methods: (1..60).map { |i| "method_#{i}" },
        type: :models,
        relative_path: "test_class.rb",
        associations: [],
        includes: []
      }
      examples = []
      doc = generator.send(:generate_component_doc, component, examples)
      expect(doc).to include("truncated to first 50 entries")
      expect(doc.scan(/method_\d+/).length).to eq(50)
    end
  end

  describe "#generate_vitepress_config" do
    it "formats appearance as false" do
      allow(OpenRemote::Config).to receive(:VITEPRESS_APPEARANCE).and_return(false)
      allow(generator).to receive(:generate_nav_config).and_return([])
      allow(generator).to receive(:generate_sidebar_config_all).and_return({})
      allow(OpenRemote::Config).to receive(:DOCS_VITEPRESS_CONFIG_DIR).and_return(Rails.root.join("tmp"))
      allow(OpenRemote::Config).to receive(:VITEPRESS_BASE_PATH).and_return("/")
      allow(OpenRemote::Config).to receive(:VITEPRESS_OUT_DIR).and_return("dist")
      allow(OpenRemote::Config).to receive(:VITEPRESS_CACHE_DIR).and_return(".cache")
      allow(OpenRemote::Config).to receive(:APP_NAME).and_return("Test")
      allow(OpenRemote::Config).to receive(:APP_DESCRIPTION).and_return("Test")
      allow(OpenRemote::Config).to receive(:VITEPRESS_LANG).and_return("en")
      allow(OpenRemote::Config).to receive(:VITEPRESS_LAST_UPDATED).and_return(true)
      allow(OpenRemote::Config).to receive(:VITEPRESS_IGNORE_DEAD_LINKS).and_return(false)

      generator.send(:generate_vitepress_config)
      config_file = Rails.root.join("tmp/config.js")
      if File.exist?(config_file)
        content = File.read(config_file)
        expect(content).to include("appearance: false")
      end
    end

    it "formats appearance as default true for unknown values" do
      allow(OpenRemote::Config).to receive(:VITEPRESS_APPEARANCE).and_return(nil)
      allow(generator).to receive(:generate_nav_config).and_return([])
      allow(generator).to receive(:generate_sidebar_config_all).and_return({})
      allow(OpenRemote::Config).to receive(:DOCS_VITEPRESS_CONFIG_DIR).and_return(Rails.root.join("tmp"))
      allow(OpenRemote::Config).to receive(:VITEPRESS_BASE_PATH).and_return("/")
      allow(OpenRemote::Config).to receive(:VITEPRESS_OUT_DIR).and_return("dist")
      allow(OpenRemote::Config).to receive(:VITEPRESS_CACHE_DIR).and_return(".cache")
      allow(OpenRemote::Config).to receive(:APP_NAME).and_return("Test")
      allow(OpenRemote::Config).to receive(:APP_DESCRIPTION).and_return("Test")
      allow(OpenRemote::Config).to receive(:VITEPRESS_LANG).and_return("en")
      allow(OpenRemote::Config).to receive(:VITEPRESS_LAST_UPDATED).and_return(true)
      allow(OpenRemote::Config).to receive(:VITEPRESS_IGNORE_DEAD_LINKS).and_return(false)

      generator.send(:generate_vitepress_config)
      config_file = Rails.root.join("tmp/config.js")
      if File.exist?(config_file)
        content = File.read(config_file)
        expect(content).to include("appearance: true")
      end
    end
  end
end
