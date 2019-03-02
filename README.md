# Bulldozer [![CircleCI](https://circleci.com/gh/SeasonedSoftware/bulldozer/tree/master.svg?style=svg)](https://circleci.com/gh/SeasonedSoftware/bulldozer/tree/master)

Bulldozer is the base Rails application used at
[seasoned](https://seasoned.cc/).

  ![Bulldozer](https://banner2.kisspng.com/20180509/epe/kisspng-excavator-architectural-engineering-bulldozer-logo-5af28c67e988a6.8792375915258450959566.jpg)

## Installation

First install the bulldozer gem:

    gem install bulldozer

Then run:

    bulldozer projectname

This will create a Rails app in `projectname` using the latest version of Rails.

### Associated services

* Enable [Circle CI](https://circleci.com/) Continuous Integration
* Enable [GitHub auto deploys to Heroku staging and review
    apps](https://dashboard.heroku.com/apps/app-name-staging/deploy/github).

## Gemfile

To see the latest and greatest gems, look at Bulldozer'
[Gemfile](templates/Gemfile.erb), which will be appended to the default
generated projectname/Gemfile.

It includes application gems like:

* [Autoprefixer Rails](https://github.com/ai/autoprefixer-rails) for CSS vendor prefixes
* [Bourbon](https://github.com/SeasonedSoftware/bourbon) for Sass mixins
* [Bitters](https://github.com/SeasonedSoftware/bitters) for scaffold application styles
* [Delayed Job](https://github.com/collectiveidea/delayed_job) for background
  processing
* [High Voltage](https://github.com/SeasonedSoftware/high_voltage) for static pages
* [Honeybadger](https://honeybadger.io) for exception notification
* [Neat](https://github.com/SeasonedSoftware/neat) for semantic grids
* [Normalize](https://necolas.github.io/normalize.css/) for resetting browser styles
* [Oj](http://www.ohler.com/oj/)
* [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
* [Rack Canonical Host](https://github.com/tylerhunt/rack-canonical-host) to
  ensure all requests are served from the same domain
* [Rack Timeout](https://github.com/heroku/rack-timeout) to abort requests that are
  taking too long
* [Recipient Interceptor](https://github.com/croaky/recipient_interceptor) to
  avoid accidentally sending emails to real people from staging
* [Simple Form](https://github.com/plataformatec/simple_form) for form markup
  and style
* [Skylight](https://www.skylight.io/) for monitoring performance
* [Title](https://github.com/calebthompson/title) for storing titles in
  translations
* [Puma](https://github.com/puma/puma) to serve HTTP requests

And development gems like:

* [Dotenv](https://github.com/bkeepers/dotenv) for loading environment variables
* [Pry Rails](https://github.com/rweng/pry-rails) for interactively exploring
  objects
* [ByeBug](https://github.com/deivid-rodriguez/byebug) for interactively
  debugging behavior
* [Bullet](https://github.com/flyerhzm/bullet) for help to kill N+1 queries and
  unused eager loading
* [Bundler Audit](https://github.com/rubysec/bundler-audit) for scanning the
  Gemfile for insecure dependencies based on published CVEs
* [Spring](https://github.com/rails/spring) for fast Rails actions via
  pre-loading
* [Web Console](https://github.com/rails/web-console) for better debugging via
  in-browser IRB consoles.

And testing gems like:

* [Capybara](https://github.com/jnicklas/capybara) and
  [Google Chromedriver]
  integration testing
* [Factory Bot](https://github.com/SeasonedSoftware/factory_bot) for test data
* [Formulaic](https://github.com/SeasonedSoftware/formulaic) for integration testing
  HTML forms
* [RSpec](https://github.com/rspec/rspec) for unit testing
* [RSpec Mocks](https://github.com/rspec/rspec-mocks) for stubbing and spying
* [Shoulda Matchers](https://github.com/SeasonedSoftware/shoulda-matchers) for common
  RSpec matchers
* [Timecop](https://github.com/travisjeffery/timecop) for testing time

## Other goodies

Bulldozer also comes with:

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

[setup]: https://robots.seasoned.cc/bin-setup
[compress]: https://robots.seasoned.cc/content-compression-with-rack-deflater
[pool]: https://devcenter.heroku.com/articles/concurrency-and-database-connections
[binstub]: https://github.com/SeasonedSoftware/bulldozer/pull/282
[i18n]: https://github.com/SeasonedSoftware/bulldozer/pull/304
[circle]: https://circleci.com/docs
[hound]: https://houndci.com
[segment]: https://segment.com

## Heroku

You can optionally create Heroku staging and production apps:

    bulldozer app --heroku true

This:

* Creates a staging and production Heroku app
* Sets them as `staging` and `production` Git remotes
* Configures staging with `HONEYBADGER_ENV` environment variable set
  to `staging`
* Creates a [Heroku Pipeline] for review apps
* Schedules automated backups for 10AM UTC for both `staging` and `production`

[Heroku Pipeline]: https://devcenter.heroku.com/articles/pipelines

You can optionally specify alternate Heroku flags:

    bulldozer app \
      --heroku true \
      --heroku-flags "--region eu --addons sendgrid,ssl"

See all possible Heroku flags:

    heroku help create

## Git

This will initialize a new git repository for your Rails app. You can
bypass this with the `--skip-git` option:

    bulldozer app --skip-git true

## GitHub

You can optionally create a GitHub repository for the suspended Rails app. It
requires that you have [Hub](https://github.com/github/hub) on your system:

    curl https://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub
    bulldozer app --github organization/project

This has the same effect as running:

    hub create organization/project

## Spring

Bulldozer uses [spring](https://github.com/rails/spring) by default.
It makes Rails applications load faster, but it might introduce confusing issues
around stale code not being refreshed.
If you think your application is running old code, run `spring stop`.
And if you'd rather not use spring, add `DISABLE_SPRING=1` to your login file.

## Dependencies

Bulldozer requires the latest version of Ruby.

Some gems included in Bulldozer have native extensions. You should have GCC
installed on your machine before generating an app with Bulldozer.

Use [OS X GCC Installer](https://github.com/kennethreitz/osx-gcc-installer/) for
Snow Leopard (OS X 10.6).

Use [Command Line Tools for Xcode](https://developer.apple.com/downloads/index.action)
for Lion (OS X 10.7) or Mountain Lion (OS X 10.8).

We use [Google Chromedriver] for full-stack JavaScript integration testing. It
requires Google Chrome or Chromium.

[Google Chromedriver]: https://sites.google.com/a/chromium.org/chromedriver/home

PostgreSQL needs to be installed and running for the `db:create` rake task.

## Issues

If you have problems, please create a
[GitHub Issue](https://github.com/SeasonedSoftware/bulldozer/issues).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

Thank you, [contributors]!

[contributors]: https://github.com/SeasonedSoftware/bulldozer/graphs/contributors

## License

Bulldozer is Copyright © 2008-2017 seasoned.
It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: LICENSE

## About seasoned

[![seasoned][seasoned-logo]][seasoned]

Bulldozer is maintained and funded by seasoned, inc.
The names and logos for seasoned are trademarks of seasoned, inc.

We love open source software!
See [our other projects][community].
We are [available for hire][hire].

[seasoned]: https://seasoned.cc?utm_source=github
[seasoned-logo]: http://presskit.seasoned.cc/images/seasoned-logo-for-readmes.svg
[community]: https://seasoned.cc/community?utm_source=github
[hire]: https://seasoned.cc?utm_source=github
