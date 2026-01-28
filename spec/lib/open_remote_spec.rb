require "rails_helper"
require "open_remote"

RSpec.describe OpenRemote do
  it "is a module" do
    expect(OpenRemote).to be_a(Module)
  end

  it "has an Engine" do
    expect(OpenRemote::Engine).to be_a(Class)
    expect(OpenRemote::Engine.superclass).to eq(Rails::Engine)
  end

  it "has a Version constant" do
    expect(OpenRemote::VERSION).to be_a(String)
    expect(OpenRemote::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
