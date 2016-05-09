require "spec_helper"

RSpec.describe "Command line help output" do
  let(:help_text) { suspenders_help_command }

  it "does not contain the default rails usage statement" do
    expect(help_text).not_to include("rails new APP_PATH [options]")
  end

  it "provides the correct usage statement for suspenders" do
    expect(help_text).to include <<~EOH
      Usage:
        suspenders APP_PATH [options]
    EOH
  end

  it "does not contain the default rails group" do
    expect(help_text).not_to include("Rails options:")
  end

  it "provides help and version usage within the suspenders group" do
    expect(help_text).to include <<~EOH
Suspenders options:
  -h, [--help], [--no-help]        # Show this help message and quit
  -v, [--version], [--no-version]  # Show Suspenders version number and quit
EOH
  end

  it "does not show the default extended rails help section" do
    expect(help_text).not_to include("Create suspenders files for app generator.")
  end

  it "contains the usage statement from the suspenders gem" do
    expect(help_text).to include IO.read(usage_file)
  end
end
