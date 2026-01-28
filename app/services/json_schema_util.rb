##
# Lightweight JSON Schema helper inspired by OpenRemote's `JSONSchemaUtil`.
#
# This utility is intentionally focused on the small subset of behaviour
# exercised by the local RSpec suite: title handling, primitive type remapping,
# enum support, "additionalProperties" defaults, and simple required flags.
module JsonSchemaUtil
  module_function

  ##
  # Build a JSON Schema document for a simple object type.
  #
  # @param name [String] logical name of the type (used for debugging only)
  # @param properties [Hash{Symbol=>Hash}] property definitions
  # @option properties [Symbol] :type Ruby-ish primitive type
  # @option properties [Boolean] :required whether the property is required
  # @option properties [Array] :enum possible values (for enum properties)
  # @option properties [String] :title optional property title/description
  # @param title [String,nil] optional schema title
  # @param additional_properties [Boolean] whether extra properties are allowed
  # @return [Hash] JSON Schema draft-style hash
  def build_schema(name:, properties:, title: nil, additional_properties: true)
    schema = {
      "type" => "object",
      "additionalProperties" => additional_properties,
      "properties" => {},
      "required" => []
    }

    schema["title"] = title if title

    properties.each do |prop_name, options|
      schema["properties"][prop_name.to_s] = build_property_schema(options)
      schema["required"] << prop_name.to_s if options[:required]
    end

    schema["required"].uniq!
    schema["required"].compact!
    schema.delete("required") if schema["required"].empty?

    schema
  end

  ##
  # Map a single property definition into JSON Schema form.
  #
  # @param options [Hash] property options (see {build_schema})
  # @return [Hash] JSON Schema fragment
  def build_property_schema(options)
    type = options[:type]
    base =
      case type
      when :string
        { "type" => "string" }
      when :integer, :int, :byte
        { "type" => "integer" }
      when :number, :float, :double
        { "type" => "number" }
      when :boolean, :bool
        { "type" => "boolean" }
      when :array
        { "type" => "array", "items" => { "type" => "string" } }
      when :object, :hash
        { "type" => "object" }
      when :enum
        { "type" => "string" }
      else
        # Fallback to string to keep schemas broadly compatible.
        { "type" => "string" }
      end

    base["title"] = options[:title] if options[:title]
    base["enum"] = options[:enum] if options[:enum]
    base
  end
end
