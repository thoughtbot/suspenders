require "spec_helper"

RSpec.describe Suspenders::ProfilerGenerator, type: :generator do
  before_invoke = proc do
    copy_file "README.md.erb", "README.md"
  end

  describe "invoke" do
    it "generates a rack-mini-profiler initializer" do
      with_fake_app do
        invoke! Suspenders::ProfilerGenerator, &before_invoke

        expect("config/initializers/rack_mini_profiler.rb").to \
          match_contents(/Rack::MiniProfilerRails.initialize/)
      end
    end

    it "adds a rack-mini-profiler entry to the README" do
      with_fake_app do
        invoke! Suspenders::ProfilerGenerator, &before_invoke

        expect("README.md")
          .to match_contents(/Profiler/)
          .and match_contents(/rack-mini-profiler/)
      end
    end

    it "bundles the rack-mini-profiler gem" do
      with_fake_app do
        invoke! Suspenders::ProfilerGenerator, &before_invoke

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(/rack-mini-profiler/)
      end
    end

    it "adds rack-mini-profiler env variables to .sample.env" do
      with_fake_app do
        invoke! Suspenders::ProfilerGenerator, &before_invoke

        expect(".sample.env").to match_contents(/RACK_MINI_PROFILER=0/)
      end
    end
  end

  describe "revoke" do
    it "destroys the rack-mini-profiler initializer" do
      with_fake_app do
        invoke_then_revoke! Suspenders::ProfilerGenerator, &before_invoke

        expect("config/initializers/rack_mini_profiler.rb").not_to exist_as_a_file
      end
    end

    it "removes the rack-mini-profiler entry from the README" do
      with_fake_app do
        invoke_then_revoke! Suspenders::ProfilerGenerator, &before_invoke

        expect("README.md")
          .to not_match_contents(/Profiler/)
          .and not_match_contents(/rack-mini-profiler/)
      end
    end

    it "removes the rack-mini-profiler gem" do
      with_fake_app do
        invoke_then_revoke! Suspenders::ProfilerGenerator, &before_invoke

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end

    it "removes the rack-mini-profiler env variables" do
      with_fake_app do
        invoke_then_revoke! Suspenders::ProfilerGenerator, &before_invoke

        expect(".sample.env").not_to match_contents(/RACK_MINI_PROFILER=0/)
      end
    end
  end
end
