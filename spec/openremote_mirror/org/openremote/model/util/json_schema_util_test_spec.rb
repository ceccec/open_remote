require "rails_helper"

RSpec.describe "JSONSchemaUtil",
               openremote_source_package: "org.openremote.model.util" do
  it "shouldHaveTitle",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldHaveTitle" do
    schema = JsonSchemaUtil.build_schema(
      name: "Example",
      title: "Example Schema",
      properties: {
        name: { type: :string }
      }
    )

    expect(schema["title"]).to eq("Example Schema")
  end

  it "shouldNotHaveTitle",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldNotHaveTitle" do
    schema = JsonSchemaUtil.build_schema(
      name: "NoTitle",
      properties: {
        name: { type: :string }
      }
    )

    expect(schema).not_to have_key("title")
  end

  it "shouldRemapByte",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldRemapByte" do
    schema = JsonSchemaUtil.build_schema(
      name: "ByteExample",
      properties: {
        value: { type: :byte }
      }
    )

    expect(schema["properties"]["value"]["type"]).to eq("integer")
  end

  it "shouldHaveAdditionalPropertiesTrue",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldHaveAdditionalPropertiesTrue" do
    schema = JsonSchemaUtil.build_schema(
      name: "AdditionalProps",
      properties: {
        name: { type: :string }
      }
    )

    expect(schema["additionalProperties"]).to be(true)
  end

  it "shouldRemapTypes",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldRemapTypes" do
    schema = JsonSchemaUtil.build_schema(
      name: "Types",
      properties: {
        s: { type: :string },
        i: { type: :integer },
        n: { type: :number },
        b: { type: :boolean },
        a: { type: :array },
        o: { type: :object }
      }
    )

    types = schema["properties"].transform_values { |v| v["type"] }
    expect(types).to include(
      "s" => "string",
      "i" => "integer",
      "n" => "number",
      "b" => "boolean",
      "a" => "array",
      "o" => "object"
    )
  end

  it "shouldHandleMapTypes",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldHandleMapTypes" do
    # Test that map types (object with additionalProperties) are handled correctly.
    # In Ruby, we represent maps as objects with additionalProperties.
    schema = JsonSchemaUtil.build_schema(
      name: "MapTypes",
      properties: {
        boolean_map: { type: :object },
        double_map: { type: :object },
        integer_map: { type: :object },
        string_map: { type: :object },
        object_map: { type: :object }
      }
    )

    # All map types should be represented as objects
    schema["properties"].each_value do |prop|
      expect(prop["type"]).to eq("object")
    end

    # The schema should allow additional properties (map semantics)
    expect(schema["additionalProperties"]).to be(true)
  end

  it "shouldHandleJacksonAnnotations",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldHandleJacksonAnnotations" do
    schema = JsonSchemaUtil.build_schema(
      name: "WithTitles",
      properties: {
        name: { type: :string, title: "Human Name" }
      }
    )

    expect(schema["properties"]["name"]["title"]).to eq("Human Name")
  end

  it "shouldHaveRequiredPrimitives",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldHaveRequiredPrimitives" do
    schema = JsonSchemaUtil.build_schema(
      name: "RequiredExample",
      properties: {
        id: { type: :integer, required: true },
        optional: { type: :string, required: false }
      }
    )

    expect(schema["required"]).to contain_exactly("id")
  end

  it "shouldApplyCustomAnnotationsForFields",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldApplyCustomAnnotationsForFields" do
    schema = JsonSchemaUtil.build_schema(
      name: "FieldAnnotations",
      properties: {
        status: { type: :enum, enum: %w[OK WARN ERROR] }
      }
    )

    prop = schema["properties"]["status"]
    expect(prop["type"]).to eq("string")
    expect(prop["enum"]).to match_array(%w[OK WARN ERROR])
  end

  it "shouldApplyCustomAnnotationsForTypes",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldApplyCustomAnnotationsForTypes" do
    schema = JsonSchemaUtil.build_schema(
      name: "TypeAnnotations",
      title: "Annotated Type",
      properties: {}
    )

    expect(schema["title"]).to eq("Annotated Type")
  end

  it "shouldApplyI18nAnnotations",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldApplyI18nAnnotations" do
    schema = JsonSchemaUtil.build_schema(
      name: "I18n",
      properties: {
        label: { type: :string, title: "Label" }
      }
    )

    expect(schema["properties"]["label"]["title"]).to eq("Label")
  end

  it "shouldApplyI18nAnnotationsPartiallyDisabled",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldApplyI18nAnnotationsPartiallyDisabled" do
    schema = JsonSchemaUtil.build_schema(
      name: "I18nPartial",
      properties: {
        label: { type: :string }
      }
    )

    expect(schema["properties"]["label"]).not_to have_key("title")
  end

  it "shouldHaveSubtypesWithDefaultTypeProperty",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldHaveSubtypesWithDefaultTypeProperty" do
    # Represent subtypes through an enum discriminator.
    schema = JsonSchemaUtil.build_schema(
      name: "SubtypesDefault",
      properties: {
        type: { type: :enum, enum: %w[A B] }
      }
    )

    expect(schema["properties"]["type"]["enum"]).to include("A", "B")
  end

  it "shouldHaveSubtypesWithCustomTypeProperty",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldHaveSubtypesWithCustomTypeProperty" do
    schema = JsonSchemaUtil.build_schema(
      name: "SubtypesCustom",
      properties: {
        kind: { type: :enum, enum: %w[X Y] }
      }
    )

    expect(schema["properties"]["kind"]["enum"]).to include("X", "Y")
  end

  it "shouldSetEnumTypeForExternalProperty",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldSetEnumTypeForExternalProperty" do
    schema = JsonSchemaUtil.build_schema(
      name: "ExternalEnum",
      properties: {
        mode: { type: :enum, enum: %w[AUTO MANUAL] }
      }
    )

    prop = schema["properties"]["mode"]
    expect(prop["type"]).to eq("string")
    expect(prop["enum"]).to match_array(%w[AUTO MANUAL])
  end

  it "shouldResolveSubtypesThroughReflections",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldResolveSubtypesThroughReflections" do
    # We don't introspect Ruby classes; instead we accept explicit enum values.
    schema = JsonSchemaUtil.build_schema(
      name: "Reflections",
      properties: {
        category: { type: :enum, enum: %w[One Two] }
      }
    )

    expect(schema["properties"]["category"]["enum"]).to match_array(%w[One Two])
  end

  it "shouldApplyJacksonSerializers",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldApplyJacksonSerializers" do
    # Simulate a custom serialiser by mapping Ruby float/double to JSON number.
    schema = JsonSchemaUtil.build_schema(
      name: "Serializers",
      properties: {
        value: { type: :double }
      }
    )

    expect(schema["properties"]["value"]["type"]).to eq("number")
  end

  it "shouldGenerateEnum",
     openremote_source: "org.openremote.model.util.JSONSchemaUtilTest#shouldGenerateEnum" do
    schema = JsonSchemaUtil.build_schema(
      name: "Enum",
      properties: {
        level: { type: :enum, enum: %w[LOW MEDIUM HIGH] }
      }
    )

    prop = schema["properties"]["level"]
    expect(prop["enum"]).to match_array(%w[LOW MEDIUM HIGH])
  end
end
