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
