require_relative "base"

module Suspenders
  class RunnerGenerator < Generators::Base
    def procfile
      copy_file "Procfile", "Procfile"
    end

    def sample_env
      copy_file "sample_env", ".sample.env"
    end

    def copy_sample_env
      if bin_setup_is_ruby?
        inject_template_into_file(
          "bin/setup",
          "partials/runner_setup.rb",
          before: %{  puts "\\n== Preparing database =="},
        )
      elsif bin_setup_mentions_ci?
        inject_into_file(
          "bin/setup",
          %{  cp -i .sample.env .env\n},
          after: %{if [ -z "$CI" ]; then\n},
        )
      else
        append_to_file(
          "bin/setup",
          %{\nif [ -z "$CI" ]; then\n  cp -i .sample.env .env\nfi},
        )
      end
    end

    def update_readme
      append_template_to_file "README.md", "partials/runner_readme.md"
    end

    private

    def bin_setup_is_ruby?
      File.read("bin/setup", 20).match?(%r{#!/usr/bin/env ruby})
    end

    def bin_setup_mentions_ci?
      File.read("bin/setup").match?(/if \[ -z "\$CI" \]/)
    end
  end
end
