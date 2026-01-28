require "rails_helper"

RSpec.describe "UniqueIdentifierGenerator", openremote_source_package: "org.openremote.model.util" do
  it "generatedAssetIdHasExpectedLength",
     openremote_source: "org.openremote.model.util.UniqueIdentifierGeneratorTest#generatedAssetIdHasExpectedLength" do
    id = UniqueIdentifierGenerator.generate_id("masterlight-1-1")
    expect(id.length).to eq(22)
  end
end
