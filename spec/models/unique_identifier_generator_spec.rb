require "rails_helper"

RSpec.describe UniqueIdentifierGenerator do
  it "generates deterministic IDs when a name is provided" do
    id1 = described_class.generate_id("asset-name")
    id2 = described_class.generate_id("asset-name")
    expect(id1).to eq(id2)
  end

  it "generates non-deterministic IDs when no name is provided" do
    id1 = described_class.generate_id
    id2 = described_class.generate_id
    expect(id1).not_to eq(id2)
    expect(id1.length).to be > 0
    expect(id2.length).to be > 0
  end

  it "returns the first alphabet character when bytes are all zero" do
    zero_bytes = "\x00" * 16
    id = described_class.send(:base62_encode, zero_bytes)
    expect(id).to eq(described_class::ALPHABET[0])
  end
end
