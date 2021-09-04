require "spec_helper"

RSpec.describe Suspenders::AdvisoriesGenerator, type: :generator do
  describe "invoke" do
    it "generates a bundler-audit rake task" do
      with_fake_app do
        invoke! Suspenders::AdvisoriesGenerator

        expect("lib/tasks/bundler_audit.rake")
          .to have_no_syntax_error
          .and(match_contents(/Bundler::Audit::Task.new/))
      end
    end

    context "when rails env is development" do
      it "the bundler-audit rake task can be executed" do
        with_fake_app do
          invoke! Suspenders::AdvisoriesGenerator

          expect(`RAILS_ENV=development rake -I#{fakes_path} -rfake_rails -T`)
            .to eq("Fake task loaded\n")
        end
      end
    end

    context "when rails env is test" do
      it "the bundler-audit rake task can be executed" do
        with_fake_app do
          invoke! Suspenders::AdvisoriesGenerator

          expect(`RAILS_ENV=test rake -I#{fakes_path} -rfake_rails -T`)
            .to eq("Fake task loaded\n")
        end
      end
    end

    context "when rails env is production" do
      it "the bundler-audit rake task can be executed" do
        with_fake_app do
          invoke! Suspenders::AdvisoriesGenerator

          expect(`RAILS_ENV=production rake -I#{fakes_path} -rfake_rails -T`)
            .to be_empty
        end
      end
    end

    it "bundles the bundler-audit gem" do
      with_fake_app do
        invoke! Suspenders::AdvisoriesGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(/bundler-audit/)
      end
    end
  end

  describe "revoke" do
    it "destroys the bundler-audit rake task" do
      with_fake_app do
        invoke_then_revoke! Suspenders::AdvisoriesGenerator

        expect("lib/tasks/bundler_audit.rake").not_to exist_as_a_file
      end
    end

    it "removes the bundler-audit gem from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Suspenders::AdvisoriesGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end
  end
end
