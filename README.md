# Suspenders [![Build Status](https://secure.travis-ci.org/thoughtbot/suspenders.svg?branch=master)](http://travis-ci.org/thoughtbot/suspenders)

Suspenders is the base Rails application used at
[thoughtbot](http://thoughtbot.com).

  ![Suspenders boy](http://media.tumblr.com/1TEAMALpseh5xzf0Jt6bcwSMo1_400.png)

## Installation

First install the suspenders gem:

    gem install suspenders

Then run:

    suspenders projectname

This will create a Rails app in `projectname` using the latest version of Rails.

## Gemfile

To see the latest and greatest gems, look at Suspenders'
[Gemfile](templates/Gemfile.erb), which will be appended to the default
generated projectname/Gemfile.

It includes application gems like:

* [Airbrake](https://github.com/airbrake/airbrake) for exception notification
* [Autoprefixer Rails](https://github.com/ai/autoprefixer-rails) for CSS vendor prefixes
* [Bourbon](https://github.com/thoughtbot/bourbon) for Sass mixins
* [Bitters](https://github.com/thoughtbot/bitters) for scaffold application styles
* [Delayed Job](https://github.com/collectiveidea/delayed_job) for background
  processing
* [Email Validator](https://github.com/balexand/email_validator) for email
  validation
* [Flutie](https://github.com/thoughtbot/flutie) for `page_title` and `body_class` view
  helpers
* [High Voltage](https://github.com/thoughtbot/high_voltage) for static pages
* [jQuery Rails](https://github.com/rails/jquery-rails) for jQuery
* [Neat](https://github.com/thoughtbot/neat) for semantic grids
* [New Relic RPM](https://github.com/newrelic/rpm) for monitoring performance
* [Normalize](https://necolas.github.io/normalize.css/) for resetting browser styles
* [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
* [Rack Canonical Host](https://github.com/tylerhunt/rack-canonical-host) to
  ensure all requests are served from the same domain
* [Rack Timeout](https://github.com/kch/rack-timeout) to abort requests that are
  taking too long
* [Recipient Interceptor](https://github.com/croaky/recipient_interceptor) to
  avoid accidentally sending emails to real people from staging
* [Refills](https://github.com/thoughtbot/refills) for “copy-paste” components
  and patterns based on Bourbon, Neat and Bitters
* [Simple Form](https://github.com/plataformatec/simple_form) for form markup
  and style
* [Title](https://github.com/calebthompson/title) for storing titles in
  translations
* [Puma](https://github.com/puma/puma) to serve HTTP requests

And development gems like:

* [Dotenv](https://github.com/bkeepers/dotenv) for loading environment variables
* [Pry Rails](https://github.com/rweng/pry-rails) for interactively exploring
  objects
* [ByeBug](https://github.com/deivid-rodriguez/byebug) for interactively
  debugging behavior
* [Bundler Audit](https://github.com/rubysec/bundler-audit) for scanning the
  Gemfile for insecure dependencies based on published CVEs
* [Spring](https://github.com/rails/spring) for fast Rails actions via
  pre-loading
* [Web Console](https://github.com/rails/web-console) for better debugging via
  in-browser IRB consoles.

And testing gems like:

* [Capybara](https://github.com/jnicklas/capybara) and
  [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit) for
  integration testing
* [Factory Girl](https://github.com/thoughtbot/factory_girl) for test data
* [Formulaic](https://github.com/thoughtbot/formulaic) for integration testing
  HTML forms
* [RSpec](https://github.com/rspec/rspec) for unit testing
* [RSpec Mocks](https://github.com/rspec/rspec-mocks) for stubbing and spying
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for common
  RSpec matchers
* [Timecop](https://github.com/jtrupiano/timecop-console) for testing time

## Other goodies

Suspenders also comes with:

* The [`./bin/setup`][setup] convention for new developer setup
* The `./bin/deploy` convention for deploying to Heroku
* Rails' flashes set up and in application layout
* A few nice time formats set up for localization
* `Rack::Deflater` to [compress responses with Gzip][compress]
* A [low database connection pool limit][pool]
* [Safe binstubs][binstub]
* [t() and l() in specs without prefixing with I18n][i18n]
* An automatically-created `SECRET_KEY_BASE` environment variable in all
  environments
* Configuration for [CircleCI][circle] Continuous Integration (tests)
* Configuration for [Hound][hound] Continuous Integration (style)
* The analytics adapter [Segment][segment] (and therefore config for Google
  Analytics, Intercom, Facebook Ads, Twitter Ads, etc.)

[setup]: http://robots.thoughtbot.com/bin-setup
[compress]: http://robots.thoughtbot.com/content-compression-with-rack-deflater/
[pool]: https://devcenter.heroku.com/articles/concurrency-and-database-connections
[binstub]: https://github.com/thoughtbot/suspenders/pull/282
[i18n]: https://github.com/thoughtbot/suspenders/pull/304
[circle]: https://circleci.com/docs
[hound]: https://houndci.com
[segment]: https://segment.com

## Heroku

By default, suspenders will create Heroku staging and production apps. To turn
off this behavior:

    suspenders app --heroku false

The Heroku integration:

* Creates a staging and production Heroku app
* Sets them as `staging` and `production` Git remotes
* Configures staging with `RACK_ENV` and `RAILS_ENV` environment variables set
  to `staging`
* Adds the [Rails Stdout Logging][logging-gem] gem
  to configure the app to log to standard out,
  which is how [Heroku's logging][heroku-logging] works.

[logging-gem]: https://github.com/heroku/rails_stdout_logging
[heroku-logging]: https://devcenter.heroku.com/articles/logging#writing-to-your-log

You can optionally specify alternate Heroku flags:

    suspenders app \
      --heroku-flags "--region eu --addons newrelic,sendgrid,ssl"

See all possible Heroku flags:

    heroku help create

## Git

This will initialize a new git repository for your Rails app. You can
bypass this with the `--skip-git` option:

    suspenders app --skip-git true

## GitHub

You can optionally create a GitHub repository for the suspended Rails app. It
requires that you have [Hub](https://github.com/github/hub) on your system:

    curl http://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub
    suspenders app --github organization/project

This has the same effect as running:

    hub create organization/project

## Spring

Suspenders uses [spring](https://github.com/rails/spring) by default.
It makes Rails applications load faster, but it might introduce confusing issues
around stale code not being refreshed.
If you think your application is running old code, run `spring stop`.
And if you'd rather not use spring, add `DISABLE_SPRING=1` to your login file.

## Dependencies

Suspenders requires the latest version of Ruby.

Some gems included in Suspenders have native extensions. You should have GCC
installed on your machine before generating an app with Suspenders.

Use [OS X GCC Installer](https://github.com/kennethreitz/osx-gcc-installer/) for
Snow Leopard (OS X 10.6).

Use [Command Line Tools for XCode](https://developer.apple.com/downloads/index.action)
for Lion (OS X 10.7) or Mountain Lion (OS X 10.8).

We use [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit) for
full-stack JavaScript integration testing. It requires QT. Instructions for
installing QT are
[here](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit).

PostgreSQL needs to be installed and running for the `db:create` rake task.

## Issues

If you have problems, please create a
[GitHub Issue](https://github.com/thoughtbot/suspenders/issues).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

Thank you, [contributors]!

[contributors]: https://github.com/thoughtbot/suspenders/graphs/contributors

## Need Help?

We offer 1-on-1 coaching. We can help you set up a new Rails application, write
your first feature, and get up and running on Heroku. [Get in touch].

[Get in touch]: http://coaching.thoughtbot.com/rails/?utm_source=github

## License

Suspenders is Copyright © 2008-2015 thoughtbot.
It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: LICENSE

## About thoughtbot

![thoughtbot](https://thoughtbot.com/logo.png)

Suspenders is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community].
We are [available for hire][hire].

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com?utm_source=github
