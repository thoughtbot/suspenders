require "spec_helper"

RSpec.describe "Command line help output" do
  let(:help_text) { bulldozer_help_command }

  it "does not contain the default rails usage statement" do
    expect(help_text).not_to include("rails new APP_PATH [options]")
  end

  it "provides the correct usage statement for bulldozer" do
    expect(help_text).to include <<~EOH
      Usage:
        bulldozer APP_PATH [options]
    EOH
  end

  it "does not contain the default rails group" do
    expect(help_text).not_to include("Rails options:")
  end

  it "provides help and version usage within the bulldozer group" do
    expect(help_text).to include <<~EOH
Bulldozer options:
  -h, [--help], [--no-help]        # Show this help message and quit
  -v, [--version], [--no-version]  # Show Bulldozer version number and quit
EOH
  end

  it "does not show the default extended rails help section" do
    expect(help_text).not_to include("Create bulldozer files for app generator.")
  end

  it "contains the usage statement from the bulldozer gem" do
    expect(help_text).to include IO.read(usage_file)
  end
end
