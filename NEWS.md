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
