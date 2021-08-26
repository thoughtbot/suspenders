require "spec_helper"

RSpec.describe Suspenders::AdvisoriesGenerator, type: :generator do
  it "generates and destroys bundler-audit" do
    with_fake_app do
      invoke! Suspenders::AdvisoriesGenerator

      expect("lib/tasks/bundler_audit.rake")
        .to have_no_syntax_error
        .and(match_contents(/Bundler::Audit::Task.new/))
      expect("Gemfile")
        .to have_no_syntax_error
        .and have_bundled("install")
        .matching(/bundler-audit/)

      revoke! Suspenders::AdvisoriesGenerator

      expect("lib/tasks/bundler_audit.rake").not_to exist_as_a_file
      expect("Gemfile")
        .to have_no_syntax_error
        .and match_original_file
        .and not_have_bundled
    end
  end

  context "when rails env is development" do
    it "includes the bundler audit task" do
      with_fake_app do
        invoke! Suspenders::AdvisoriesGenerator

        expect(`RAILS_ENV=development rake -I#{fakes_path} -rfake_rails -T`)
          .to eq("Fake task loaded\n")
      end
    end
  end

  context "when rails env is test" do
    it "includes the bundler audit task" do
      with_fake_app do
        invoke! Suspenders::AdvisoriesGenerator

        expect(`RAILS_ENV=test rake -I#{fakes_path} -rfake_rails -T`)
          .to eq("Fake task loaded\n")
      end
    end
  end

  context "when rails env is production" do
    it "does not include the bundler audit task" do
      with_fake_app do
        invoke! Suspenders::AdvisoriesGenerator

        expect(`RAILS_ENV=production rake -I#{fakes_path} -rfake_rails -T`)
          .to be_empty
      end
    end
  end
end
