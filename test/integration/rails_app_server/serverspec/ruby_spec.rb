require "spec_helper"

describe "Ruby" do

  it "is in the PATH" do
    expect(command("which ruby").stdout).to eq "/usr/local/ruby/bin/ruby\n"
  end

  # Keep this in sync with the `node[:ruby_version]` default
  it "is the default version" do
    expect(command("ruby -v").stdout).to match(/^ruby 2\.3\.1/)
  end

end
