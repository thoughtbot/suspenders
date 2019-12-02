require "spec_helper"

RSpec.describe "suspenders:advisories", type: :generator do
  it "configures bundler-audit" do
    with_app { generate("suspenders:advisories") }

    run_in_project do
      expect(`rake -T`).to include("rake bundle:audit")
    end
    expect("lib/tasks/bundler_audit.rake").to \
      match_contents(/Bundler::Audit::Task.new/)
    expect("Gemfile").to match_contents(/bundler-audit/)
  end

  it "removes bundler-audit" do
    with_app { destroy("suspenders:advisories") }

    expect("Gemfile").not_to match_contents(/bundler-audit/)
    expect("lib/tasks/bundler_audit.rake").not_to exist_as_a_file
    run_in_project do
      expect(`rake -T`).not_to include("rake bundle:audit")
    end
  end
end
