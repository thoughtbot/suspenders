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
        copy_command = <<~RUBY
          puts "\\n== Copying sample env =="
          system! 'cp -i .sample.env .env'

        RUBY

        insert_into_file(
          "bin/setup",
          copy_command,
          before: %{  puts "\\n== Preparing database =="},
        )
      elsif bin_setup_mentions_ci?
        insert_into_file(
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
      configure = <<~MARKDOWN

        ## Configuration

        Environment variables during local development are handled by the node-foreman
        project runner. To provide environment variables, create a `.env` file at the
        root of the project. In that file provide the environment variables listed in
        `.sample.env`. The `bin/setup` script does this for you, but be careful about
        overwriting your existing `.env` file.

        `app.json` also contains a list of environment variables that are required for
        the application. The `.sample.env` file provides either non-secret vars that
        can be copied directly into your own `.env` file or instructions on where to
        obtain secret values.

        During development add any new environment variables needed by the application
        to both `.sample.env` and `app.json`, providing either **public** default
        values or brief instructions on where secret values may be found.

        Do not commit the `.env` file to the git repo.

        ## Running the Application

        Use the `heroku local` runner to run the app locally as it would run on Heroku.
        This uses the node-forman runner, which reads from the `Procfile` file.

        ```sh
        heroku local
        ```

        Once the server is started the application is reachable at
        `http://localhost:3000`.
      MARKDOWN

      append_to_file "README.md", configure
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
