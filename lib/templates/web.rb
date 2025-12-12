# Methods like `copy_file` will accept relative paths to the template's location.
def source_paths
  Array(super) + [__dir__]
end

def install_gems
  gem "inline_svg"
  gem "sidekiq"
  gem "strong_migrations"

  gem_group :test do
    # TODO: How can we ensure we're notified of new releases?
    gem "action_dispatch-testing-integration-capybara",
      github: "thoughtbot/action_dispatch-testing-integration-capybara", tag: "v0.2.0",
      require: "action_dispatch/testing/integration/capybara/rspec"
    gem "capybara"
    gem "capybara_accessibility_audit"
    # TODO: How can we ensure we're notified of new releases?
    gem "capybara_accessible_selectors",
      git: "https://github.com/citizensadvice/capybara_accessible_selectors", tag: "v0.12.0"
    gem "selenium-webdriver"
    gem "shoulda-matchers", "~> 6.0"
    gem "webmock"
  end

  gem_group :development, :test do
    gem "factory_bot_rails"
    gem "rspec-rails", "~> 8.0.0"
  end
end

install_gems

after_bundle do
  # Initializers & Configuration
  configure_database
  configure_test_suite
  configure_ci
  configure_sidekiq
  configure_strong_migrations
  configure_mailer_intercepter
  configure_inline_svg

  # Environments
  setup_development_environment
  setup_production_environment
  setup_application

  # Deployment and server
  update_bin_dev
  add_procfiles

  # Views
  update_layout

  # Finalization
  run_migrations
  update_readme
  lint_codebase

  print_message
end

def configure_database
  gsub_file "config/database.yml", /^production:.*?password:.*?\n/m, <<~YAML
    production:
      <<: *default
      url: <%= ENV["DATABASE_URL"] %>
  YAML
end

def configure_test_suite
  rails_command "generate rspec:install"

  # Update default configuration
  uncomment_lines "spec/rails_helper.rb", /config\.infer_spec_type_from_file_location!/
  uncomment_lines "spec/rails_helper.rb", /Rails\.root\.glob/
  gsub_file "spec/spec_helper.rb", /^=begin\n/, ""
  gsub_file "spec/spec_helper.rb", /^=end\n/, ""

  # Configure Webmock
  inject_into_file "spec/spec_helper.rb", "require \"webmock/rspec\"\n", before: /^RSpec\.configure/
  append_to_file "spec/spec_helper.rb", <<~RUBY

    WebMock.disable_net_connect!(
      allow_localhost: true,
      allow: [
        /(chromedriver|storage).googleapis.com/,
        "googlechromelabs.github.io"
      ]
    )
  RUBY

  # Custom configuration
  copy_file "spec/support/action_mailer.rb"
  copy_file "spec/support/driver.rb"
  copy_file "spec/support/i18n.rb"
  copy_file "spec/support/factory_bot.rb"
  copy_file "spec/support/shoulda_matchers.rb"

  # Custom specs
  copy_file "spec/factories_spec.rb"
  empty_directory "spec/system"
  create_file "spec/system/.gitkeep"
end

def configure_ci
  # https://thoughtbot.com/blog/rspec-rails-github-actions-configuration
  append_to_file ".github/workflows/ci.yml", "\n" + <<~YAML.gsub(/^/, "  ")
    test:
      runs-on: ubuntu-latest

      services:
        postgres:
          image: postgres
          env:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: postgres
          ports:
            - 5432:5432
          options: --health-cmd="pg_isready" --health-interval=10s --health-timeout=5s --health-retries=3

        # redis:
        #   image: valkey/valkey:8
        #   ports:
        #     - 6379:6379
        #   options: --health-cmd "redis-cli ping" --health-interval 10s --health-timeout 5s --health-retries 5

      steps:
        - name: Install packages
          run: sudo apt-get update && sudo apt-get install --no-install-recommends -y libpq-dev

        - name: Checkout code
          uses: actions/checkout@v5

        - name: Set up Ruby
          uses: ruby/setup-ruby@v1
          with:
            bundler-cache: true

        - name: Run tests
          env:
            RAILS_ENV: test
            DATABASE_URL: postgres://postgres:postgres@localhost:5432
            RAILS_MASTER_KEY: ${{ secrets.RAILS_MASTER_KEY }}
            # REDIS_URL: redis://localhost:6379/0
          run: bin/rails db:test:prepare test

    system-test:
      runs-on: ubuntu-latest

      services:
        postgres:
          image: postgres
          env:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: postgres
          ports:
            - 5432:5432
          options: --health-cmd="pg_isready" --health-interval=10s --health-timeout=5s --health-retries=3

        # redis:
        #   image: valkey/valkey:8
        #   ports:
        #     - 6379:6379
        #   options: --health-cmd "redis-cli ping" --health-interval 10s --health-timeout 5s --health-retries 5

      steps:
        - name: Install packages
          run: sudo apt-get update && sudo apt-get install --no-install-recommends -y libpq-dev

        - name: Checkout code
          uses: actions/checkout@v5

        - name: Set up Ruby
          uses: ruby/setup-ruby@v1
          with:
            bundler-cache: true

        - name: Run System Tests
          env:
            RAILS_ENV: test
            DATABASE_URL: postgres://postgres:postgres@localhost:5432
            RAILS_MASTER_KEY: ${{ secrets.RAILS_MASTER_KEY }}
            # REDIS_URL: redis://localhost:6379/0
          run: bin/rails db:setup spec

        - name: Keep screenshots from failed system tests
          uses: actions/upload-artifact@v4
          if: failure()
          with:
            name: screenshots
            path: ${{ github.workspace }}/tmp/capybara
            if-no-files-found: ignore
  YAML
end

def configure_sidekiq
  # TODO: Use #initializer instead
  copy_file "config/initializers/sidekiq.rb"

  prepend_to_file "config/routes.rb", "require \"sidekiq/web\"\n\n"
  sidekiq_route = <<-RUBY
  if Rails.env.local?
    mount Sidekiq::Web => "/sidekiq"
  end

  RUBY
  insert_into_file "config/routes.rb", sidekiq_route, after: "Rails.application.routes.draw do\n  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html\n"

  # https://github.com/sidekiq/sidekiq/wiki/Active+Job
  environment "config.active_job.queue_adapter = :sidekiq"
  environment "config.active_job.queue_adapter = :inline", env: "test"
end

def configure_strong_migrations
  rails_command "generate strong_migrations:install"
end

def configure_mailer_intercepter
  lib "email_interceptor.rb", <<~RUBY
    class EmailInterceptor
      def self.delivering_email(message)
        message.to = ENV.fetch("INTERCEPTOR_ADDRESSES", "").split(",")
      end
    end
  RUBY

  initializer "email_interceptor.rb", <<~RUBY
    Rails.application.configure do
      if ENV.fetch("INTERCEPTOR_ADDRESSES", "").split(",").any?
        config.action_mailer.interceptors = %w[EmailInterceptor]
      end
    end
  RUBY
end

def configure_inline_svg
  initializer "inline_svg.rb", <<~RUBY
    InlineSvg.configure do |config|
      config.raise_on_file_not_found = true
    end
  RUBY
end

def setup_development_environment
  environment "config.active_model.i18n_customize_full_message = true", env: "development"
  uncomment_lines "config/environments/development.rb", /config\.i18n\.raise_on_missing_translations/
  uncomment_lines "config/environments/development.rb", /config\.generators\.apply_rubocop_autocorrect_after_generate!/
end

def setup_production_environment
  environment "config.sandbox_by_default = true", env: "production"
  environment "config.active_record.action_on_strict_loading_violation = :log", env: "production"
  gsub_file "config/environments/production.rb", /# config\.asset_host =.*$/, 'config.asset_host = ENV["ASSET_HOST"]'
  gsub_file "config/environments/production.rb", /config\.action_mailer\.default_url_options = \{ host: .*? \}/, 'config.action_mailer.default_url_options = { host: ENV.fetch("APPLICATION_HOST") }'
end

def setup_application
  environment "config.active_record.strict_loading_by_default = true"
  environment "config.active_record.strict_loading_mode = :n_plus_one_only"
  environment "config.require_master_key = true"
end

def update_bin_dev
  # https://github.com/rails/jsbundling-rails/blob/main/lib/install/dev
  # rubocop:disable Style/RedundantStringEscape
  create_file "bin/dev", force: true do
    <<~BASH
      #!/usr/bin/env sh

      if gem list --no-installed --exact --silent foreman; then
        echo "Installing foreman..."
        gem install foreman
      fi

      # Default to port 3000 if not specified
      export PORT="\${PORT:-3000}"

      exec foreman start -f Procfile.dev --env /dev/null "$@"
    BASH
  end
  # rubocop:enable Style/RedundantStringEscape

  # rubocop:disable Style/NumericLiteralPrefix
  chmod "bin/dev", 0755
  # rubocop:enable Style/NumericLiteralPrefix
end

def add_procfiles
  copy_file "Procfile"
  copy_file "Procfile.dev"
end

def update_layout
  # General partials
  copy_file "app/views/application/_form_errors.html.erb"
  copy_file "app/views/application/_flashes.html.erb"

  # Application Layout
  gsub_file "app/views/layouts/application.html.erb", /<html>/, "<html lang=\"<%= I18n.locale %>\">"
  application_html_erb = <<-ERB
    <main class="container" aria-labelledby="main_label">
      <%= render "flashes" %>
      <%= yield %>
    </main>
  ERB
  gsub_file "app/views/layouts/application.html.erb", /^    <%= yield %>\n/, application_html_erb
  insert_into_file "app/views/layouts/application.html.erb", "    <meta name=\"turbo-prefetch\" content=\"false\">\n", after: "</title>\n"
end

def run_migrations
  rails_command "db:create"
  rails_command "db:migrate"
end

def update_readme
  create_file "README.md", force: true do
    <<~MARKDOWN
      # README

      ## Local Development

      Uses [Strong Migrations][] to catch unsafe migrations in development.

      [Strong Migrations]: https://github.com/ankane/strong_migrations

      ## Environment Variables

      The following environment variables are available in `production`:

      - `APPLICATION_HOST` - The domain where your application is hosted (required)
      - `ASSET_HOST` - CDN or asset host URL (optional)
      - `RAILS_MASTER_KEY` - Used for decrypting credentials (required)

      ## Configuration

      ### All Environments

      - Enables [strict_loading_by_default][].
      - Sets [strict_loading_mode][] to `:n_plus_one`.
      - Enables [require_master_key][].

      [strict_loading_by_default]: https://guides.rubyonrails.org/configuring.html#config-active-record-strict-loading-by-default
      [strict_loading_mode]: https://guides.rubyonrails.org/configuring.html#config-active-record-strict-loading-mode
      [require_master_key]: https://guides.rubyonrails.org/configuring.html#config-require-master-key

      ### Test

      - Enables [raise_on_missing_translations][].
      - Disables [action_dispatch.show_exceptions][].

      [raise_on_missing_translations]: https://guides.rubyonrails.org/configuring.html#config-i18n-raise-on-missing-translations
      [action_dispatch.show_exceptions]: https://edgeguides.rubyonrails.org/configuring.html#config-action-dispatch-show-exceptions

      ### Development

      - Enables [raise_on_missing_translations][].
      - Enables [i18n_customize_full_message][].
      - Enables [apply_rubocop_autocorrect_after_generate!][].

      [raise_on_missing_translations]: https://guides.rubyonrails.org/configuring.html#config-i18n-raise-on-missing-translations
      [i18n_customize_full_message]: https://guides.rubyonrails.org/configuring.html#config-active-model-i18n-customize-full-message
      [apply_rubocop_autocorrect_after_generate!]: https://guides.rubyonrails.org/configuring.html#configuring-generators

      ### Production

      - Enables [sandbox_by_default][].
      - Sets [action_on_strict_loading_violation][] to `:log`.

      [sandbox_by_default]: https://guides.rubyonrails.org/configuring.html#config-sandbox-by-default
      [action_on_strict_loading_violation]: https://guides.rubyonrails.org/configuring.html#config-active-record-action-on-strict-loading-violation

      ## Testing

      Uses [RSpec][] and [RSpec Rails][] in favor of the [default test suite][].

      The test suite can be run with `bin/rails spec`.

      Configuration can be found in the following files:

      ```
      spec/rails_helper.rb
      spec/spec_helper.rb
      spec/support/action_mailer.rb
      spec/support/driver.rb
      spec/support/i18n.rb
      spec/support/shoulda_matchers.rb
      ```

      - Uses [action_dispatch-testing-integration-capybara][] to introduce Capybara assertions into Request specs.
      - Uses [shoulda-matchers][] for simple one-liner tests for common Rails functionality.
      - Uses [webmock][] for stubbing and setting expectations on HTTP requests in Ruby.

      [RSpec]: http://rspec.info
      [RSpec Rails]: https://github.com/rspec/rspec-rails
      [default test suite]: https://guides.rubyonrails.org/testing.html
      [action_dispatch-testing-integration-capybara]: https://github.com/thoughtbot/action_dispatch-testing-integration-capybara
      [shoulda-matchers]: https://github.com/thoughtbot/shoulda-matchers
      [webmock]: https://github.com/bblimke/webmock

      ### Factories

      Uses [FactoryBot][] as an alternative to [Fixtures][] to help you define
      dummy and test data for your test suite. The `create`, `build`, and
      `build_stubbed` class methods are directly available to all tests.

      Place FactoryBot definitions in `spec/factories.rb`, at least until it
      grows unwieldy. This helps reduce confusion around circular dependencies and
      makes it easy to jump between definitions.

      [FactoryBot]: https://github.com/thoughtbot/factory_bot
      [Fixtures]: https://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures

      ## Accessibility

      Uses [capybara_accessibility_audit][] and
      [capybara_accessible_selectors][] to encourage and enforce accessibility best
      practices.

      [capybara_accessibility_audit]: https://github.com/thoughtbot/capybara_accessibility_audit
      [capybara_accessible_selectors]: https://github.com/citizensadvice/capybara_accessible_selectors

      ## Mailers

      [Intercept][] emails in non-production environments by setting `INTERCEPTOR_ADDRESSES`.

      ```sh
      INTERCEPTOR_ADDRESSES="user_1@example.com,user_2@example.com" bin/rails s
      ```

      Configuration can be found at `config/initializers/email_interceptor.rb`.

      Interceptor can be found at `lib/email_interceptor.rb`.

      [Intercept]: https://guides.rubyonrails.org/action_mailer_basics.html#intercepting-emails

      ## Jobs

      Uses [Sidekiq][] for [background job][] processing.

      Configures the `test` environment to use the [inline][] adapter.

      [Sidekiq]: https://github.com/sidekiq/sidekiq
      [background job]: https://guides.rubyonrails.org/active_job_basics.html
      [inline]: https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters/InlineAdapter.html

      ## Layout and Assets

      ### Inline SVG

      Uses [inline_svg][] for embedding SVG documents into views.

      Configuration can be found at `config/initializers/inline_svg.rb`

      [inline_svg]: https://github.com/jamesmartin/inline_svg

      ### Layout

      - A [partial][] for [flash messages][] is located in `app/views/application/_flashes.html.erb`.
      - A [partial][] for form errors is located in `app/views/application/_form_errors.html.erb`.
      - Sets [lang][] attribute on `<html>` element to `en` via `I18n.local`.
      - Disables Turbo's [Prefetch][] in an effort to reduce unnecessary network requests.

      [partial]: https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials
      [flash messages]: https://guides.rubyonrails.org/action_controller_overview.html#the-flash
      [lang]: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/lang
      [title]: https://github.com/calebhearth/title
      [Prefetch]: https://turbo.hotwired.dev/handbook/drive#prefetching-links-on-hover
    MARKDOWN
  end
end

def lint_codebase
  run "bin/rubocop -a"
end

def print_message
  say ""
  say "Congratulations! You just pulled our suspenders."
  say ""
  say ralph
end

def ralph
  <<~ASCII
    ##################################################
    ################+                 ################
    ############                          -###########
    #########       =################*.      :########
    #######-    =####=               =####     #######
    ########+ ###+                       +##+ ########
    ###########.     .###############-      ##########
    ###########=  +####=          :+####*  ###########
    ###############=                   *##############
    ##############     +###########-    ##############
    ###############=*#################+###############
    ##################################################
    #########:                               #########
    #########                                 ########
    #########                                 ########
    #########        ##.           +#=        ########
    #########      #=   #        #*   #.      ########
    #########      #.   #        #=   #:      ########
    #########       :##+           ###        ########
    #########                                 ########
    #########                                 ########
    #########                                 ########
    #########                                 ########
    #########+                               #########
    ##################################################
    ##################################################
  ASCII
end
