require "spec_helper"

RSpec.describe "bulldozer:production:deployment", type: :generator do
  it "generates the configuration for a production deployment" do
    rm "bin/deploy"

    with_app { generate("bulldozer:production:deployment") }

    expect("bin/deploy").to exist_as_a_file
    expect("bin/deploy").to be_executable
    expect("README.md").to match_contents(%r{bin/deploy})
  end

  it "destroys the configuration for a production deployment" do
    touch "bin/deploy"

    with_app { destroy("bulldozer:production:deployment") }

    expect("bin/deploy").not_to exist_as_a_file
    expect("README.md").not_to match_contents(%r{bin/deploy})
  end
end
