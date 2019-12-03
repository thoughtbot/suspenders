require_relative "base"

module Suspenders
  class ProfilerGenerator < Generators::Base
    def augment_default_env
      append_to_file ".env", "RACK_MINI_PROFILER=0\n"
    rescue Errno::ENOENT
      create_file ".env", "RACK_MINI_PROFILER=0\n"
    rescue Thor::Error => e
      if e.message.match?(/does not appear to exist/)
        create_file ".env", "RACK_MINI_PROFILER=0\n"
      else
        raise
      end
    end

    def add_gem
      gem "rack-mini-profiler", require: false
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_rack_mini_profiler
      copy_file(
        "rack_mini_profiler.rb",
        "config/initializers/rack_mini_profiler.rb",
        force: false,
        skip: true,
      )
    end

    def update_readme
      config = <<~CONFIG

        ## Profiler

        The [rack-mini-profiler] gem can be enabled by setting
        `RACK_MINI_PROFILER=1` in the environment. This will display a speed
        badge on every page.

        [rack-mini-profiler]: https://github.com/MiniProfiler/rack-mini-profiler
      CONFIG
      append_to_file "README.md", config
    end
  end
end
