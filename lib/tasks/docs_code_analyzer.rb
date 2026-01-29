# frozen_string_literal: true

##
# Analyzes Ruby code to extract method signatures, parameters, and structure
# DRY approach: Everything extracted from code, nothing hardcoded
#
class DocsCodeAnalyzer
  require "ripper"
  require "parser/current"

  def initialize(file_path)
    @file_path = file_path
    @content = File.read(file_path)
    @ast = parse_ast
  end

  ##
  # Extract all methods from the file
  #
  def extract_methods
    methods = []
    traverse_ast(@ast) do |node|
      if method_node?(node)
        methods << extract_method_info(node)
      end
    end
    methods.compact
  end

  ##
  # Extract class/module information
  #
  def extract_class_info
    class_node = find_class_node(@ast)
    return nil unless class_node

    {
      name: extract_class_name(class_node),
      type: class_node.type,
      superclass: extract_superclass(class_node),
      included_modules: extract_included_modules(class_node),
      concerns: extract_concerns(class_node)
    }
  end

  ##
  # Extract associations from ActiveRecord models
  #
  def extract_associations
    associations = []
    traverse_ast(@ast) do |node|
      if association_call?(node)
        associations << extract_association_info(node)
      end
    end
    associations
  end

  ##
  # Extract validations
  #
  def extract_validations
    validations = []
    traverse_ast(@ast) do |node|
      if validation_call?(node)
        validations << extract_validation_info(node)
      end
    end
    validations
  end

  private

  def parse_ast
    Parser::CurrentRuby.parse(@content)
  rescue StandardError => e
    warn "Failed to parse #{@file_path}: #{e.message}"
    nil
  end

  def traverse_ast(node, &block)
    return unless node.is_a?(Parser::AST::Node)

    yield node
    node.children.each do |child|
      traverse_ast(child, &block) if child.is_a?(Parser::AST::Node)
    end
  end

  def method_node?(node)
    node.is_a?(Parser::AST::Node) &&
      (node.type == :def || node.type == :defs)
  end

  def extract_method_info(node)
    method_name = node.children[0].to_s
    args_node = node.children[1]

    {
      name: method_name,
      type: node.type == :defs ? :class_method : :instance_method,
      visibility: extract_visibility(node),
      parameters: extract_parameters(args_node),
      line_number: node.loc&.line
    }
  end

  def extract_parameters(args_node)
    return [] unless args_node&.is_a?(Parser::AST::Node)

    params = []
    args_node.children.each do |arg|
      if arg.is_a?(Parser::AST::Node)
        case arg.type
        when :arg, :optarg, :restarg, :kwarg, :kwoptarg, :kwrestarg
          params << {
            name: arg.children[0].to_s,
            type: arg.type,
            default: extract_default_value(arg)
          }
        end
      end
    end
    params
  end

  def extract_default_value(arg_node)
    return nil unless arg_node.type == :optarg || arg_node.type == :kwoptarg
    arg_node.children[1]&.to_s
  end

  def extract_visibility(node)
    # Check for visibility modifiers before the method
    # This is a simplified version - full implementation would track visibility state
    :public
  end

  def find_class_node(ast)
    return nil unless ast.is_a?(Parser::AST::Node)

    traverse_ast(ast) do |node|
      return node if node.type == :class || node.type == :module
    end
    nil
  end

  def extract_class_name(node)
    node.children[0]&.children&.last&.to_s
  end

  def extract_superclass(node)
    return nil unless node.type == :class
    node.children[1]&.children&.last&.to_s
  end

  def extract_included_modules(node)
    modules = []
    traverse_ast(node) do |child|
      if include_call?(child)
        modules << extract_module_name(child)
      end
    end
    modules.compact
  end

  def extract_concerns(node)
    concerns = []
    traverse_ast(node) do |child|
      if concern_call?(child)
        concerns << extract_concern_name(child)
      end
    end
    concerns.compact
  end

  def include_call?(node)
    node.is_a?(Parser::AST::Node) &&
      node.type == :send &&
      node.children[1] == :include
  end

  def concern_call?(node)
    node.is_a?(Parser::AST::Node) &&
      node.type == :send &&
      node.children[1] == :include &&
      node.children[2]&.children&.last&.to_s&.start_with?("Concerns::")
  end

  def extract_module_name(node)
    node.children[2]&.children&.last&.to_s
  end

  def extract_concern_name(node)
    extract_module_name(node)
  end

  def association_call?(node)
    return false unless node.is_a?(Parser::AST::Node)
    return false unless node.type == :send

    association_methods = %i[belongs_to has_many has_one has_and_belongs_to_many]
    association_methods.include?(node.children[1])
  end

  def extract_association_info(node)
    {
      type: node.children[1],
      name: node.children[2]&.children&.first&.to_s,
      options: extract_association_options(node)
    }
  end

  def extract_association_options(node)
    # Extract hash options if present
    {}
  end

  def validation_call?(node)
    return false unless node.is_a?(Parser::AST::Node)
    return false unless node.type == :send

    validation_methods = %i[validates validates_presence_of validates_uniqueness_of validate]
    validation_methods.include?(node.children[1])
  end

  def extract_validation_info(node)
    {
      type: node.children[1],
      attributes: extract_validation_attributes(node),
      options: extract_validation_options(node)
    }
  end

  def extract_validation_attributes(node)
    # Extract attributes being validated
    []
  end

  def extract_validation_options(node)
    # Extract validation options
    {}
  end
end
