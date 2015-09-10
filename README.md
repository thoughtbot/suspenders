# Suspenders

[![Stories in Backlog](https://badge.waffle.io/philosophie/suspenders.svg?label=ready&title=Backlog)](http://waffle.io/philosophie/suspenders)

This is Philosophie's fork of Suspenders, a Rails application template
originally created by thoughtbot. This repo has strayed significantly from
thoughtbot's and is not intended to go back upstream.

## Installation

First install the gem:

    gem install philosophies-suspenders

Or update if you already have the gem installed:

    gem update philosophies-suspenders

Then run:

    philosophies-suspenders projectname

This will create a Rails app in `projectname` using the latest version of Rails.

## Gemfile

To see the latest and greatest gems, look at Suspenders'
[Gemfile](templates/Gemfile.erb), which will be appended to the default
generated projectname/Gemfile. After the first bundle install, Suspenders will
apply pessimistic version-locking on the Gemfile to only allow patch-level
updates.

It includes application gems like:

* [Airbrake](https://github.com/airbrake/airbrake) for exception notification,
  set your API key in the environment with `AIRBRAKE_API_KEY`
* [Autoprefixer Rails](https://github.com/ai/autoprefixer-rails) for CSS vendor prefixes
* [Sidekiq](https://github.com/mperham/sidekiq) for background processing
* [Flutie](https://github.com/thoughtbot/flutie) for `page_title` and `body_class` view
  helpers
* [Rails Assets](https://rails-assets.org/) for managing frontend dependencies,
  including by default:
  * jquery
  * jquery-ujs
* [New Relic RPM](https://github.com/newrelic/rpm) for monitoring performance
* [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
* [Rack Canonical Host](https://github.com/tylerhunt/rack-canonical-host) to
  ensure all requests are served from the same domain
* [Rack Timeout](https://github.com/kch/rack-timeout) to abort requests that are
  taking too long
* [Simple Form](https://github.com/plataformatec/simple_form) for form markup
  and style
* [Title](https://github.com/calebthompson/title) for storing titles in
  translations
* [Unicorn](https://github.com/defunkt/unicorn) to serve HTTP requests

And development gems like:

* [Dotenv](https://github.com/bkeepers/dotenv) for loading environment variables
* [Pry Rails](https://github.com/rweng/pry-rails) for interactively exploring
  objects
* [Pry ByeBug](https://github.com/deivid-rodriguez/pry-byebug) for interactively
  debugging behavior
* [Bundler Audit](https://github.com/rubysec/bundler-audit) for scanning the
  Gemfile for insecure dependencies based on published CVEs
* [Spring](https://github.com/rails/spring) for fast Rails actions via
  pre-loading
* [Better Errors](https://github.com/charliesome/better_errors) for better
  debugging via in-browser IRB consoles.
* [RuboCop](https://github.com/bbatsov/rubocop) with Philosophie's default
  configuration to enforce Ruby Community Styleguide.

And testing gems like:

* [Capybara](https://github.com/jnicklas/capybara) and
  [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit) for
  integration testing
* [Factory Girl](https://github.com/thoughtbot/factory_girl) for test data
* [RSpec](https://github.com/rspec/rspec) for unit testing
* [RSpec Mocks](https://github.com/rspec/rspec-mocks) for stubbing and spying
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for common
  RSpec matchers
* [Timecop](https://github.com/jtrupiano/timecop-console) for testing time

## Other goodies

Suspenders also comes with:

* [Stairs][stairs] for new developer setup
* Rails' flashes set up and in application layout
* A few nice time formats set up for localization
* `Rack::Deflater` to [compress responses with Gzip][compress]
* A [low database connection pool limit][pool]
* [Safe binstubs][binstub]
* [t() and l() in specs without prefixing with I18n][i18n]
* An automatically-created `SECRET_KEY_BASE` environment variable in all
  environments
* The analytics adapter [Segment][segment] (and therefore config for Google
  Analytics, Intercom, Facebook Ads, Twitter Ads, etc.)

[stairs]: https://github.com/philosophie/stairs
[compress]: http://robots.thoughtbot.com/content-compression-with-rack-deflater/
[pool]: https://devcenter.heroku.com/articles/concurrency-and-database-connections
[binstub]: https://github.com/thoughtbot/suspenders/pull/282
[i18n]: https://github.com/thoughtbot/suspenders/pull/304
[segment]: https://segment.com

## CSS Frameworks

You can optionally install a CSS Framework
options: bourbon_n_friends, bootstrap, foundation

    philosophies-suspenders my_new_app --css-framework=CSS_FRAMEWORK

## Heroku

By default, suspenders will:

* Creates a staging and production Heroku app
* Sets them as `staging` and `production` Git remotes
* Configures staging with `RACK_ENV` and `RAILS_ENV` environment variables set
  to `staging`
* Adds the [Rails 12factor][rails-12factor] gem
* Adds free Mandrill add-on and configure SMTP settings to use it
* Adds free Airbrake add-on
* Adds free Papertrail add-on

[rails-12factor]: https://github.com/heroku/rails_12factor

You can optionally specify alternate Heroku flags:

    philosophies-suspenders app \
      --heroku-flags "--region eu --addons newrelic,pgbackups,ssl"

See all possible Heroku flags:

    heroku help create

You can bypass all Heroku functionality with the `--skip-heroku` option:

    suspenders app --skip-heroku true

## Git

By default, suspenders will:

* Initialize a new git repository
* Create `staging` and `production` branches for deployment
* Make an initial commit

You can optionally provide a remote URL via the `--origin` option and suspenders
will push all branches to that remote.

    suspenders app --origin git@github.com:philosopie/app.git

You can bypass all git functionality with the `--skip-git` option:

    philosophies-suspenders app --skip-git true

## GitHub

You can optionally create a GitHub repository for the suspended Rails app. It
requires that you have [Hub](https://github.com/github/hub) on your system:

    curl http://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub
    philosophies-suspenders app --github organization/project

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

## Contributing / Feature requests

Philosophie's Suspenders is meant to support the core functionality of a new rails project. Many nice to have features are therefore not appropriate. If you have an idea for a new feature, here are the steps for having it added:

- please bring your idea up in the #nerds channel first to gauge it's popularity
- if you are able to, create a PR for the new functionality
- if you need help creating a PR find someone to pair with

## License

Suspenders is Copyright © 2008-2015 thoughtbot.
It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: LICENSE
