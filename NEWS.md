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
