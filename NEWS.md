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
