Unreleased

20250317.0 (March 17, 2025)

Support Rails 8.

* Fixed: [Force creation of GitHub Actions CI workflow](https://github.com/thoughtbot/suspenders/pull/1249)
* Fixed: [Remove dependabot config in favour of upstream](https://github.com/thoughtbot/suspenders/pull/1247)
* Fixed: [Switch to using yml for generated yaml files](https://github.com/thoughtbot/suspenders/pull/1246)
* Added: [Add support for Rails 8.0](https://github.com/thoughtbot/suspenders/pull/1239)
* Fixed: [Ensure `bin/setup` works](https://github.com/thoughtbot/suspenders/pull/1242)
* Fixed: [Add node_modules to .gitignore](https://github.com/thoughtbot/suspenders/pull/1235)
* Fixed: [Fix generate_readme for running the dev server](https://github.com/thoughtbot/suspenders/pull/1231)
* Added: [Allow running against suspenders main](https://github.com/thoughtbot/suspenders/pull/1230)
* Added: Require `--skip-rubocop` in favor of our [linting configuration][]
* Fixed: [Specify a tag when installing capybara_accessible_selectors](https://github.com/thoughtbot/suspenders/issues/1228)
* Fixed: [Issue 1229: How do we want to handle un-released versions?](https://github.com/thoughtbot/suspenders/issues/1229)
* Fixed: [Issue 1222: README instructions for running the development server are wrong](https://github.com/thoughtbot/suspenders/issues/1222)
* Fixed: [#1224](https://github.com/thoughtbot/suspenders/issues/1224)

[linting configuration]: https://github.com/thoughtbot/suspenders/blob/main/FEATURES.md#linting

20240516.0 (May, 16, 2024)

"Tailored" release

* Remove `suspenders` system executable and introduce [application template][]
* Introduce `suspenders:accessibility` generator
* Introduce `suspenders:inline_svg` generator
* Introduce `suspenders:factories` generator
* Introduce `suspenders:advisories` generator
* Introduce `suspenders:styles` generator
* Introduce `suspenders:jobs` generator
* Introduce `suspenders:lint` generator
* Introduce `suspenders:rake` generator
* Introduce `suspenders:views` generator
* Introduce `suspenders:setup` generator
* Introduce `suspenders:tasks` generator
* Introduce `suspenders:db:migrate` task
* Introduce `suspenders:email` generator
* Introduce `suspenders:testing` generator
* Introduce `suspenders:prerequisites` generator
* Introduce `suspenders:ci` generator
* Introduce `suspenders:cleanup:organize_gemfile` task
* Introduce `suspenders:environments:production` generator
* Introduce `suspenders:environments:test` generator
* Introduce `suspenders:environments:development` generator
* Introduce `suspenders:install:web` generator

[application template]: https://guides.rubyonrails.org/rails_application_templates.html

20230113.0 (January, 13, 2023)

Support Rails 7 and Ruby 3. Introduce CalVer.

* Upgraded: Ruby to 3.0.5
* Upgraded: Supported Rails version to 7.0.0
* Removed: Bourbon
* Removed: Bitters
* Removed: Autoprefixer Rails
* Added: cssbundling-rails
* Added: PostCSS Autoprefixer
* Added: PostCSS Normalize

1.56.1 (July 17, 2022)

Fixes a critical error with the previous release

* Run database migrations as the last step of bin/suspenders
* Fix bundler error on bin/suspenders script

1.56.0 (July 4, 2022)

Maintenance release

* Fixed: Make Suspenders fail if running with an unsupported Rails version
* Added: Update default configuration to use request specs
* Added: Add missing Errno::ECONNREFUSED to HTTP_ERRORS
* Fixed: Drop use of git in gemspec
* Fixed: Enforce bundler >= 2.1.0
* Fixed: Make suspenders abort when something goes wrong
* Fixed: Reliability and aesthetics of the config files comment stripper
* Fixed: ActionMailer asset host in the production configuration
* Added: Configure the oj gem (fast JSON parsing) when generating a new application
* Fixed: Improve error message of the match_contents matcher
* Fixed: Convert generator tests to unit tests thus speeding up the test suite
* Removed: Preloader generator / spring
* Added: Pull in DATABASE_URL env var explicitly in database.yml
* Removed: Travis CI configuration
* Upgraded: Ruby to version 2.7.4
* Added: A GitHub Action for CI
* Fixed: Run bin/suspenders in both CLI and tests against a fixed Rails version

1.55.1 (September 11, 2020)

* Fixed: Missing newline in generated development config

1.55.0 (July 15, 2020)

* Changed: lint generator to install standard instead of RuboCop
* Changed: profile generator and timeout generator to write to `.sample.env`
  instead of `.env`

1.54.1 (June 30, 2020)

* Fixed: invalid Gemfile entry for bundler-audit
* Fixed: Deprecation warning for `Bundler.with_clean_env`

1.54.0 (June 24, 2020)

* New generator: `suspenders:single_redirect` for setting up `Rack::CanonicalHost`
* New generator: `suspenders:production:compression` for setting up `Rack::Deflater`
* New generator: `suspenders:preloader` for managing spring
* New generator: `suspenders:advisories` for installing bundler-audit
* New generator: `suspenders:profiler` for setting up rack\_mini\_profiler
* New generator: `suspenders:runner` for making an app runnable locally
* Added: generator descriptions
* Added: Heroku release phase for running database migrations
* Added: automatic buildpack configuration for Heroku
* Added: system test configuration to opt into JavaScript as needed
* Added: spring-watcher-listen gem
* Changed: from `chromedriver-helper` to `webdrivers`
* Changed: replace `heroku join` calls with `heroku apps:info` in `bin/setup`
* Changed: check environment instead of `DATABASE\_URL` in test helper
* Fixed: `ExpandJson` merging
* Fixed: spacing in the generated config file
* Upgraded: bitters to version 2.x
* Upgraded: bourbon to version 6.x
* Upgraded: Ruby to version 2.6.6
* Removed: neat gem
* Removed: ctags configuration
* Removed: custom placeholder directories
* Removed: customization for error pages
* Removed: custom Puma config

1.53.0 (August 23, 2019)
* Upgraded: Rails 6.0.
* New generator: `suspenders:inline_svg` for setting up the inline_svg gem.
* Changed: silence Puma's startup messages in JS specs.
* Changed: improve chromedriver configuration.
* Added: documentation for deploying to Heroku.
* Fixed: indentation in production config file.

1.52.0 (June 7, 2019)
* Changed: Setup system tests instead of feature specs
* Upgraded: Rails 5.2.3

1.51.0 (April 26, 2019)

* Changed: from sass-rails to sassc-rails.
* Upgraded: Ruby 2.6.3.
* Fixed: Avoid installing autoprefixer-rails in api mode
* New generator: `suspenders:stylelint` for setting up stylelint.
* New generator: `suspenders:production:manifest` for app.json.
* New generator: `suspenders:production:deployment` for bin/deploy script.

1.50.0 (December 28, 2018)

* Removed: jquery-rails.
* Changed: default FactoryBot to `use_parent_strategy = true`.
* Upgraded: Ruby 2.5.3.
* Fixed: set `ASSET_HOST` and `APPLICATION_HOST` at top of `production.rb`.
* Fixed: `tzinfo-data` gem for Windows.
* New generator: `suspenders:json` for JSON parsing.
* New generator: `suspenders:staging:pull_requests` for Heroku app per PR.

1.49.0 (October 19, 2018)

* Removed: NOODP robots meta tags
* Removed: flutie gem and body class in application layout
* Upgraded: remove version constraint for pg gem
* Fixed: install JavaScript dependencies in bin/setup
* Fixed: include action_mailer SMTP settings in production config

1.48.0 (August 10, 2018)

* Bug fix: change production timeouts generator to use working configuration
  method with latest version of Rack::Timeout
* Bug fix: Only add email environment requirements if configuring for email
* Breaking: Replace capybara-webkit with chromedriver

1.47.0 (May 25, 2018)

* Bug fix: normalize.css Sass import is concatenated with other styles now
* Bug fix: the suspenders gem itself is not needed in production
* Bug fix: bundle install after adding a gem
* Breaking: remove Refills
* Breaking: rename suspenders:enforce_ssl to suspenders:production:force_tls
* Upgrade: update to Ruby 2.5.1
* Upgrade: update to Rails 5.2.0
* New generator: production email
* New generator: production timeouts

1.46.0 (January 26, 2018)

* Bug fix: Fix for action mailer asset_host
* Bug fix: Lock pg to ~> 0.18
* Breaking: Remove Database Cleaner
* Upgrade: Update to Rails 5.1.4
* Upgrade: Update to Ruby 2.5.0
* Upgrade: Update bourbon from 5.0.0.beta.8 to 5.0.0
* Upgrade: Update FactoryGirl to FactoryBot
* Generators: Analytics generator
* Generators: CI generator
* Generators: DB optimization generator
* Generators: Factories generator
* Generators: Forms generator
* Generators: Javascript driver generator
* Generators: Jobs generator
* Generators: Lint generator
* Generators: Testing driver generator
* Generators: Views generator

1.45.0 (September 8, 2017)

* Bump Rails to 5.1.3 (#857)
* Configure HONEYBADGER_ENV for staging, production (#861)
* Remove vestigial `staging` references (#860)
* Prevent memory bloat in ActiveJob children (#856)
* .git/safe is opt-in (#837)
* Enforce SSL in production environment (#855)
* Configures action mailer asset host (#853)
* Install normalize.css via yarn (#851)
* Update Rails to 5.1 (#847)
* Update bourbon from 5.0.0.beta.7 to 5.0.0.beta.8 (#848)
* Update Neat to 2.1 (#849)
* Update Bitters to 1.7 (#850)
* Fix incorrect Timecop link (#845)
* Update Ruby to 2.4.1 (#841)
* Update rspec-rails to 3.6 (#842)
* Configure TimeCop safe mode (#840)
* Pull normalize.css through Rails Assets (#839)
* Fix fatal git failures in tests (#832)
* Schedule Heroku Backups and Capture backup of existing staging database for
  Review Apps (#826)
* Use bundle-audit rake task from the gem (#831)
* Update thoughtbot logo (#829)
* Change terminal symbol in README's deploying section (#828)
* Update Segment snippet to 4.0.0 (#822)

1.44.0 (January 25, 2017)

* Improve readability of `bin/setup-review-app` (#819)
* Update scripts to be `sh`-compatible (#820)
* Remove `rails_stdout_logging` gem (#818)
* Remove `12factor` gem (#817)
* Update Ruby to 2.4.0 (#814)

1.43.0 (November 8, 2016)

* Update Bourbon to 5.0.0.beta.7
* Update Neat to 2.0.0.beta.1
* Update Bitters to 1.5.0
* Drop sprockets-es6
* Bugfix: doesn’t generate unused `test/` directory

1.42.0 (July 23, 2016)

* [#784] Require refills once
* [#790] Ensure stylesheet_base generator runs with a clean bundle
* [#791] Use Rails' 5 syntax for `public_file_server.headers`
* [#792] Remove turbolinks from application.js file

1.41.0 (July 1, 2016)

* Update to Rails 5
* Drop quiet_assets
* Drop unneeded `suspenders` aliases: `--skip-test-unit`, `--skip-turbolinks`,
  `--skip-bundle`. Drops `-G` that clashes with Rails’ `--skip-git` alias.

1.40.0 (June 25, 2016)

* Upgrade bourbon to 5.0.0.beta.6
* Update Neat to 1.8.0
* `APPLICATION_HOST` bug fix in production environment (was used before it was
  defined)
* Update comment around Pipelines: it is now a Heroku core plugin
* Drop unneeded `WEB_CONCURRENCY` from `app.json` file
* Introduce a `suspenders:stylesheet_base` generator. The `application.scss`
  must list the imports in a specific order. This removes the `application.css`.

1.39.0 (May 25, 2016)

* Update to Ruby 2.3.1
* Make new apps "deployable to Heroku" by default.
* Make the help text returned when running `suspenders -h` Suspenders specific
* Bugfix: Configure `static_cache_control` in production environment
* Replace NewRelic with Skylight
* Drop initializer for disabling XML parser
* Start moving suspenders features into different Rails Generators
* Set default `application_host` in Heroku
* Update the viewport meta tag

1.38.1 (April 20, 2016)

* Bugfix: add bitters as suspenders’ dependency back.

1.38.0 (April 15, 2016)

* Update bourbon to `v5.0.0.beta.5`
* Drops staging environment in favor of configuration through env variables
* Bugfix: failing migrations were not making Heroku deploys fail

1.37.0 (March 13, 2016)

* Remove `RAILS_ENV` definitions
* Set development `action_mailer.delivery_method` to `:file`
  so that mails are copied to `./tmp/mails/` directory for easy development
  access.
* Update Bourbon to v5.0.0.beta.3
* Update Bitters to v1.3
* Update Autoprefixer config, drop support for IE 9, IE 10 and iOS 7
* Better db support in linux environments
* Replaces coffeescript with babel
* Update CSS tests to ignore transitions

1.36.0 (February 26, 2016)

* Update Bitters to v1.2
* Remove deprecated `fix_i18n_deprecation_warning` method
* Switch from Airbrake to Honeybadger
* Generate applications with `rack_mini_profiler` (disabled by default, enabled
  by setting `RACK_MINI_PROFILER=1`)
* Heroku Pipelines bug fixes

1.35.0 (December 30, 2015)

* Introduce Heroku Pipelines support
* Update to Ruby 2.3.0
* Heroku commands run on staging by default
* Git ignore `.env.local` instead of `.env`
* Add ability to use byebug navigation commands inside of Pry using the
  `pry-byebug` gem
* Remove `i18n-tasks` from generated Gemfile
* Accessibility: Add `lang` attribute to `html` element in layout

1.34.0 (November 15, 2015)

* Fix `block_unknown_urls` deprecation warning with capybara_webkit when running
  Javascript tests
* Inherit staging's `action_mailer_host` config from production
* Suspenders command line responds to `-v` and `--version` options
* Clean up `bin/rake`
* Remove `email_validator` gem from generated Gemfile
* Fix Circle deploys by removing redundant remote
* Add `bullet` as development dependency
* Use Heroku Local (Forego) instead of Foreman
* Raise on missing Sprockets assets in test environment

1.33.0 (October 23, 2015)

* Add `quiet_assets` as development dependency
* Reduce number of Puma processes and threads to reduce memory usage
* Move non-runtime-dependency i18n-tasks to development and test Gemfile groups
* Move non-runtime-dependency refills to the development Gemfile group
* Generate empty `spec/factories.rb` file in accordance with thoughtbot’s
  styleguide
* Shoulda Matchers 3.0 configuration

1.32.0 (October 9, 2015)

* Install Foreman automatically during setup script
* Port always defaults to 3000
* Provide shoulda-matchers config
* Set CI auto-deploy for Heroku suspended apps
* Configure capybara-webkit to block unknown URLs
* Add mandatory environment variables to .sample.env
* Other bugfixes

1.31.0 (September 3, 2015)

* Update to Ruby 2.2.3
* Add ctags configuration dotfile
* Rename `$HOST` to `$APPLICATION_HOST` for zsh compatibility
* Update Bitters to 1.1
* Remove comments and newlines in config files
* Abort tests run if `DATABASE_URL` env variable is set

1.30.0 (July 30, 2015)

* Update to RSpec 3.3
* Replace TravisCI with CircleCI
* Rename development data concept to avoid confusion with db/seeds
* Remove Unicorn in favor of Puma, as [recommended by Heroku]

[recommended by Heroku]: https://devcenter.heroku.com/changelog-items/594

1.29.0 (June 16, 2015)

* Generate rake, rails and rspec binstubs with Spring
* Remove Capybara and use RSpec 3.2 for development
* Improves suspenders' test suite speed
* Refills `flashes.scss` bugfix

1.28.0 (May 9, 2015)

* Require spec/support files in a certain order
* Use rack-canonical-host
* Swap `id="flash"` for `class="flashes"` in `_flashes.html.erb`
* Provide EXECJS_RUNTIME env variable (Node, as in Heroku)
* Removes .css file suffix from application stylesheet
* Add mention of Autoprefixer Rails gem to readme
* Use ruby 2.2.2
* Update gems

1.27.0 (April 10, 2015)

* Add Autoprefixer and browserslist config file
* Only display user-facing flashes
* Add code of conduct to CONTRIBUTING document
* Only use rack-timeout in staging and production
* Add SimpleCov
* Avoid generation of extra _flashes view
* Fix Travis CI install step
* Cache bundle in Travis CI runs

1.26.0 (March 23, 2015)

* Update Rails to 4.2.1
* Update Bitters to 1.0
* Fix .ruby-version (should have been 2.1.1)
* Enable `verify_partial_doubles`
* Renames Segment.io to Segment
* Removes New Relic unnecessary configuration setting

1.25.0 (March 7, 2015)

* Configure Active Job queue adapter for test env
* Use Ruby 2.2.1 (bug: `.ruby-version` wasn’t updated in the package)
* Dasherize heroku app names
* Update Bourbon to 4.2.0
* Add ASSET_HOST to sample.env (defaults to HOST)
* Set bin/deploy script as executable
* Set email deliver method to :test for development
* Include missing word in the Flutie description in README.
* Remove unused dev gems: aruba & cucumber
* Use skip_bundle class_option (rather than defining an empty run_bundle method)

1.24.0 (February 3, 2015)

* Remove things in Suspenders that Rails does for us now.
* Document how to use the `title` view helper.
* Improve speed of bundling in `bin/setup` script.
* Set ENV variable to make out-of-the-box Heroku static asset experience better.

1.23.0 (January 19, 2015)

* Use Bourbon 4.1.0.
* Use Neat 1.7.0.
* Remove [parameter wrapping] for every format, including JSON.
* Turn off TravisCI email notifications for Suspended apps.
* Run `rake dev:prime` on CI in order to test
  whether `bin/setup` has any regressions.
* Fix `config.action_mailer.default_url_options`'s value.
  It now correctly uses `ENV.fetch("HOST")` in staging
  and production.

[parameter wrapping]: http://api.rubyonrails.org/classes/ActionController/ParamsWrapper.html

1.22.0 (January 11, 2015)

* Allow additional
  [Heroku flags](https://github.com/thoughtbot/suspenders#heroku)
  such as `--addons` and `--region`.
* Use RSpec 3.1.0.
* Use Travis' new Docker container infrastructure
  for builds that start sooner and run faster.
* Improve SMTP and ActionMailer default settings.

1.21.0 (January 4, 2015)

* Use Ruby 2.2.0.
* Use Rails 4.2.0.
* Install [Refills] and Refills' "flashes" component.
* Add `bin/deploy` script.

[Refills]: http://refills.bourbon.io/components/#flashes

1.20.0 (November 25, 2014)

* Use Ruby 2.1.5.
* Use bin/setup from TravisCI to test executable documentation.
* Default JSON time format to use ISO8601 to match Heroku API Design Guide.
* Add Bundler Audit to scan Gemfile for insecure dependencies per CVEs.

1.19.0 (November 23, 2014)

* Use Ruby 2.1.4.
* Use Rails 4.1.8.
* Add Bundler Audit gem for scanning the Gemfile
  for insecure dependencies based on published CVEs.
* Use Heroku-recommended timeout numbers.
* [Improve memory] of app on Heroku with New Relic.
* Turn off RSpec verbose mode by default.

[Improve memory]: http://forum.upcase.com/t/how-to-free-up-swap-space-heroku/3017/13?u=croaky

1.18.0 (October 23, 2014)

* Use Ruby 2.1.3.
* Move New Relic to all gem groups to more easily
  [debug Rails performance in development][debug-performance].
* Make `bin/setup` idempotent, failing fast with install messages.
* Fix unevaluated app name in generated `en.yml` locale file.
* Change `File.exists?` to `File.exist?` to fix Ruby warning.
* Don't include port 6000 as an option for Foreman; Chome considers it unsafe.
* Git ignore the entire /tmp directory.

[debug-performance]: https://upcase.com/improving-rails-performance

1.17.0 (September 30, 2014)

* Use Rails 4.1.6.
* Generate a `spec/rails_helper.rb` and `spec/spec_helper.rb` following
  RSpec 3.x's example, but using our defaults.
* Raise on missing i18n translations in test environment.
* Raise on unpermitted parameters in test environment.
* Provide example for using Title gem for internationalizing page title text.

1.16.0 (August 16, 2014)

* Use the 3.x series of RSpec.
* Use the 0.10.x series of Bitters.
* Improve documentation in generated README for machine setup via `bin/setup`
  and https://github.com/thoughtbot/laptop script.
* Remove Foreman from `Gemfile`.
* Use i18n-tasks for missing or unused translations.
* Raise on missing translations in development environment. Fail fast!
* Prevent empty div when there are no flashes.
* Pick random port when generating Rails app so multiple apps can be run via
  Foreman on a development machine at the same time.
* Add `normalize-rails` gem for resetting browser styles.

1.15.0 (July 9, 2014)

* Use Rails 4.1.4.
* Use latest thoughtbot style guidelines in generated code so that
  https://houndci.com will approve the initial commit.
* Remove Campfire in favor of Slack.
* Remove Pow in bin/setup.
* Upgrade Capybara Webkit to support Capybara 2.3 API.
* Add byebug.

1.14.0 (June 11, 2014)

* Set up Bitters during Suspenders setup. http://bitters.bourbon.io/
* Remove SimpleCov.
* Force Suspenders to use a particular Rails version (4.1.1).
* Use RSpec 2.x until Travis/Capybara issues resolve.
* Set `viewport` to `initial-scale=1`.

1.13.0 (May 29, 2014)

* Remove `FactoryGirl.lint` in `before(:suite)` in order to avoid paying and
  estimated extra ~300ms load time on a typical thoughtbot app.
* Automatically join Heroku app in `bin/setup` if using Heroku organizations.

1.12.0 (May 26, 2014)

* Fix `rake dev:prime` now that Suspenders-generated apps require some `ENV`
  variables to be set.
* Ensure `EMAIL_RECIPIENTS` is set on staging.
* Clear `ActionMailer` deliveries before every test.
* Include New Relic configuration file.
* Add Formulaic gem for integration testing HTML forms.
* Set up the Segment.io adapter for analytics and event tracking through
  services such as Google Analytics and Intercom.
* Prepare staging and production environments to serve static assets through a
  CDN.

1.11.0 (May 17, 2014)

* Generate a Rails 4.1.1 app and implement fixes for compatibility.
* Escape ERb in secrets.yml
* Maintain ActiveRecord test schema.
* Make Shoulda Matchers work with Spring.
* Unify Ruby version for gem and suspended apps.
* Move SMTP variable settings out of initializer.
* Connect to Postgres on localhost.
* Add `bin/setup` for contributors.
* Improve and document TravisCI configuration.

1.10.2 (April 28, 2014)

* Fix bundling Bourbon and Neat.

1.10.1 (April 25, 2014)

* Fix bundling sass-rails.

1.10.0 (April 21, 2014)

* Generate a Rails 4.1 app.
* Generate a working .ruby-version for Ruby >= 2.1.0.
* Update Unicorn template to version now preferred by Heroku.

1.9.3 (April 13, 2014)

* Use FactoryGirl.lint instead of custom-generated factory-testing code.
* Fix Delayed::Job <-> Rails 4.1 dependency conflict.

1.9.2 (April 10, 2014)

* Join Heroku apps in bin/setup.
* Enable SMTP/TLS in SMTP settings.
* Silence an RSpec warning.

1.9.1 (April 7, 2014)

* Fix sass-rails environment NilClass error.

1.9.0 (March 24, 2014)

* Add `awesome_print` gem.
* Add `dev:prime` task placeholder for bootstrapping local dev data.
* Add fix for I18n deprecation warning from `enforce_available_locales`.
* Add generated `.travis.yml`.
* Remove `better_errors` because of issues with Unicorn.
* Remove fast-failing for RSpec; respect user's `~/.rspec` instead.
* Update New Relic agent.
* Update Rails to 4.0.3.

1.8.1 (February 19, 2014)

* Don't distribute rspec binstub with gem.

1.8.0 (February 18, 2014)

* Make the .git/safe directory in bin/setup.
* Require `rails_12factor` gem only on Heroku.
* Require mailer config on staging and production.
* Add rspec binstub.
* Fix .ruby-version on Ruby 2.1.0.
* Replace Flutie's `page_title` with `title` gem.
* Don't run factory specs twice.
* Inherit staging config from production.
* Internal: convert tests from Cucumber to RSpec.
* Don't include `prefilled_input.js`.
* Fix Rack class name - Deflater instead of Timeout.
* Add Pry Rails.
* Add Spring.
* Add Dotenv to development and test environments to load environment variables
  from the `.env` file.
* Reduce ActiveRecord connection pool from 5 to 2.

1.7.0 (December 6, 2013)

* Keep `db/schema.rb` under version control.
* Fast-fail if any part of `bin/setup` fails.
* Move secret key out of version control.
* Create `.ruby-version` in generated applications.
* Add placeholder modules and directories for feature specs.
* Improve README to include setup instructions.

1.6.0 (November 28, 2013)

* Do not create `.rspec` file as the settings are not project-specific.
* Generate RSpec binstub at `bin/rspec`.
* Fix stylesheet error on 500, 404, and 422 static pages.
* Add `--skip-git` option.
* Disable jQuery animations in Rails integration tests that execute JavaScript.
* Fix git remote bug.
* Add `Rack::Deflater` to compress responses with Gzip.

1.5.1 (September 10, 2013)

* Remove Turbolinks.
* Don't use Bundler's binstubs in `bin/setup`.
* Remove `--drb` now that we aren't using Spork.
* Set up DNS via Pow for development.
* Update gem versions.

1.5.0 (August 3, 2013)

* Add Neat.
* Replace Bourne with RSpec Mocks.
* Replace Sham Rack with WebMock.
* Remove dependency on `hub` gem.
* Clean up leftover Rails 3 conventions.

1.4.0 (July 21, 2013)

* Support Rails 4.
* Support Ruby 2.
* Remove jQuery UI.
* Factories spec works for non-ActiveRecord objects.
* Use New Relic RPM gem >= 3.5.7 for Heroku request queue accuracy.
* Abort RSpec runs on first failure.
* Replace custom email validator with gem.

1.3.0 (May 13, 2013)

* Switch web server from Thin to Unicorn
* Set up database before setting up RSpec so that the rspec:install task works
* Add Delayed::Job
* Clean up cruft from ActionMailer delivery configuration
* strong_parameters now raises an error in development
* Enforce Ruby 1.9.2+ in the gemspec

1.2.2 (March 14, 2013)

* Fix Syntax error in staging/production environment config files.
* Make Factory Girl available to development environment for generators and
  `rails console`.

1.2.1 (February 28, 2013)

* Use Ruby 1.9.3 and 2.0
* Update staging and production email delivery
* Remove Spork and Guard
* Add better_errors and binding_of_caller gems
* Fix ActiveRecord attributes' blacklist
* Add Flutie to Gemfile

1.2.0 (February 13, 2013)

* Upgrade Rails from 3.2.8 to 3.2.12 to keep pace with security patches.
* Improve staging environment on Heroku with staging `ENV` variables and
  overriding the recipient in staging email delivery.
* Remove Flutie, use Bourbon.
* Wrap all HTTP requests in a 5 second timeout.
* Don't use `attr_accessible` whitelists. Instead, configure Strong Parameters.
* Provide a `bin/setup` script.
* Force RSpec's `expect` syntax.
* Remove remaining references to Cucumber, complete RSpec + Capybara conversion.
* Improve Foreman/`.env`/`Procfile` interactions.

1.1.5 (October 22, 2012)

* Ignore `.env`.
* Link to thoughtbot/guides in generated README.
* Remove Cucumber in favor of RSpec + Capybara.
* Deliver emails in staging environment to an overriden email or set of emails.
* Encode database as UTF8.
* Bundle with binstubs using 37signals' directory convention.
* Configure time formats using localization.
* Add Ruby version to Gemfile.
* Add fast-failing spec that tests validity of factories.
* Use SimpleCov for C0 coverage.
* Configure RSpec with `--profile` flag to find slow-running specs.

1.1.4 (September 4, 2012)

* Always store UTC in the DB.
* Use Rails 3.2.8.

1.1.3 (August 7, 2012)

* Fix broken Gemfile additions where capybara stole cucumber's `require: false`

1.1.2 (August 6, 2012)

* Fix broken rake.
* Use Heroku-compliant asset pipeline settings.

1.1.1 (August 3, 2012)

* Fix broken newline interpolation

1.1.0 (August 3, 2012)

* Add --github option.
* Add --webkit option.
* Remove cruft when generating controllers.
* Add Spork and Guard.

1.0.1 (August 2, 2012)

* Fix broken install on Ruby 1.8.
* Remove db/schema.rb from .gitignore.
* Remove Factory Girl step definitions.

1.0.0 (June 29, 2012)

* Ignore `bin/`, `.rake_tasks`, `.bundle/`, and `.gem/`.
* Create a root route only with `--clearance`.
* Do not autocommit after generate.
* Style static error pages.
* Cucumber requires everything under `features/`, regardless of pwd.
* Added gems:
  * `foreman`
  * `therubyracer`
* Removed gems:
  * `copycopter_client`
  * `heroku`
  * `ruby-debug`
  * `sass`
  * `sprockets-redirect`
  * `email_spec`
