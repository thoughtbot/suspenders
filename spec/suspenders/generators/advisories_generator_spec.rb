require "spec_helper"

RSpec.describe Suspenders::AdvisoriesGenerator, type: :generator do
  it "generates and destroys bundler-audit" do
    with_app_dir do
      generator = new_invoke_generator(Suspenders::AdvisoriesGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect("lib/tasks/bundler_audit.rake")
        .to have_no_syntax_error.and(match_contents(/Bundler::Audit::Task.new/))
      expect("Gemfile").to have_no_syntax_error
      expect(generator).to have_bundled.with_gemfile_matching(/bundler-audit/)

      generator = new_revoke_generator(Suspenders::AdvisoriesGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect("lib/tasks/bundler_audit.rake").not_to exist_as_a_file
      expect("Gemfile").to have_no_syntax_error.and(match_original_file)
    end
  end

  # TODO: Cover this functionality at the integration level
  it "lists the bundler audit task" do
    pending

    run_in_project do
      expect(`rake -T`).to include("rake bundle:audit")
    end
  end
end
