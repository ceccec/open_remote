require "rails_helper"

RSpec.describe "ValueUtil", openremote_source_package: "org.openremote.model.value" do
  it "validatePositiveInteger",
     openremote_source: "org.openremote.model.value.ValueUtilTest#validatePositiveInteger" do
    expect(ValueUtil.validate_positive_integer(1)).to be true
  end

  it "validatePositiveIntegerEmptyValue",
     openremote_source: "org.openremote.model.value.ValueUtilTest#validatePositiveIntegerEmptyValue" do
    expect(ValueUtil.validate_positive_integer(nil)).to be true
  end

  it "validatePositiveIntegerFalse",
     openremote_source: "org.openremote.model.value.ValueUtilTest#validatePositiveIntegerFalse" do
    expect(ValueUtil.validate_positive_integer(-1)).to be false
  end

  it "validateArrayOfPositiveIntegers",
     openremote_source: "org.openremote.model.value.ValueUtilTest#validateArrayOfPositiveIntegers" do
    expect(ValueUtil.validate_array_of_positive_integers([ 1, 2 ])).to be true
  end

  it "validateArrayOfPositiveIntegersEmptyValue",
     openremote_source: "org.openremote.model.value.ValueUtilTest#validateArrayOfPositiveIntegersEmptyValue" do
    expect(ValueUtil.validate_array_of_positive_integers(nil)).to be true
  end

  it "validateArrayOfPositiveIntegersFalse",
     openremote_source: "org.openremote.model.value.ValueUtilTest#validateArrayOfPositiveIntegersFalse" do
    expect(ValueUtil.validate_array_of_positive_integers([ 1, -2 ])).to be false
  end

  it "validateArrayOfArrayOfPositiveIntegers",
     openremote_source: "org.openremote.model.value.ValueUtilTest#validateArrayOfArrayOfPositiveIntegers" do
    expect(ValueUtil.validate_array_of_array_of_positive_integers([ [ 1, 2 ], [ 5, 2 ] ])).to be true
  end

  it "validateArrayOfArrayOfPositiveIntegersFalse",
     openremote_source: "org.openremote.model.value.ValueUtilTest#validateArrayOfArrayOfPositiveIntegersFalse" do
    expect(ValueUtil.validate_array_of_array_of_positive_integers([ [ 1, 2 ], [ -5, 2 ] ])).to be false
  end
end
