require "test_helper"
require "tempfile"
require_relative "../../../lib/suspenders/cleanup/generate_readme"

module Suspenders
  module Cleanup
    class GenerateReadmeTest < ActiveSupport::TestCase
      test "generates README using generator descriptions" do
        Object.any_instance.stubs(:`).returns("v20.0.0\n")

        Tempfile.create "README.md" do |readme|
          path = readme.path

          Suspenders::Cleanup::GenerateReadme.perform(path, "ExpectedAppName")

          readme.rewind
          readme = readme.read

          assert_match "# Expected App Name", readme

          assert_match "## Prerequisites", readme
          assert_match Suspenders::MINIMUM_RUBY_VERSION, readme
          assert_match "Node: `20.0.0`", readme

          assert_match "## Configuration", readme
          assert_match "### Test", readme
          assert_match Suspenders::Generators::Environments::TestGenerator.desc, readme
          assert_match "### Development", readme
          assert_match Suspenders::Generators::Environments::DevelopmentGenerator.desc, readme
          assert_match "### Production", readme
          assert_match Suspenders::Generators::Environments::ProductionGenerator.desc, readme

          assert_match "### Linting", readme
          assert_match Suspenders::Generators::LintGenerator.desc, readme

          assert_match "## Testing", readme
          assert_match Suspenders::Generators::TestingGenerator.desc, readme
          assert_match "### Factories", readme
          assert_match Suspenders::Generators::FactoriesGenerator.desc, readme

          assert_match "## Accessibility", readme
          assert_match Suspenders::Generators::AccessibilityGenerator.desc, readme

          assert_match "## Advisories", readme
          assert_match Suspenders::Generators::AdvisoriesGenerator.desc, readme

          assert_match "## Mailers", readme
          assert_match Suspenders::Generators::EmailGenerator.desc, readme

          assert_match "## Jobs", readme
          assert_match Suspenders::Generators::JobsGenerator.desc, readme

          assert_match "## Layout and Assets", readme

          assert_match "### Stylesheets", readme
          assert_match Suspenders::Generators::StylesGenerator.desc, readme
          assert_match "### Inline SVG", readme
          assert_match Suspenders::Generators::InlineSvgGenerator.desc, readme
          assert_match "### Layout", readme
          assert_match Suspenders::Generators::ViewsGenerator.desc, readme
        end
      end

      test "replaces existing README" do
        Tempfile.create "README.md" do |readme|
          path = readme.path
          readme.write "Unexpected Content"
          readme.rewind

          Suspenders::Cleanup::GenerateReadme.perform(path, "App")

          readme.rewind
          readme = readme.read

          assert_no_match "Unexpected Content", readme
        end
      end
    end
  end
end
