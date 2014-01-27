# Suspenders [![Build Status](https://secure.travis-ci.org/thoughtbot/suspenders.png?branch=master)](http://travis-ci.org/thoughtbot/suspenders)

Suspenders is the base Rails application used at [thoughtbot](http://thoughtbot.com/community).

  ![Suspenders boy](http://media.tumblr.com/1TEAMALpseh5xzf0Jt6bcwSMo1_400.png)

Installation
------------

First install the suspenders gem:

    gem install suspenders

Then run:

    suspenders projectname

This will create a Rails 4.0 app in `projectname`.

By default this script creates a new git repository. See below if you
want to use it against an existing repo.

Gemfile
-------

To see the latest and greatest gems, look at Suspenders'
[templates/Gemfile_clean](templates/Gemfile_clean),
which will be appended to the default generated projectname/Gemfile.

It includes application gems like:

* [Airbrake](https://github.com/airbrake/airbrake) for exception notification
* [Bourbon](https://github.com/thoughtbot/bourbon) for Sass mixins
* [Delayed Job](https://github.com/collectiveidea/delayed_job) for background
  processing
* [Email Validator](https://github.com/balexand/email_validator) for email
  validation
* [Flutie](https://github.com/thoughtbot/flutie) for `page_title` and
  `body_class` view helpers
* [High Voltage](https://github.com/thoughtbot/high_voltage) for static pages
* [jQuery Rails](https://github.com/rails/jquery-rails) for jQuery
* [Neat](https://github.com/thoughtbot/neat) for semantic grids
* [Postgres](https://github.com/ged/ruby-pg) for access to the Postgres database
* [Rack Timeout](https://github.com/kch/rack-timeout) to abort requests that are
  taking too long
* [Recipient Interceptor](https://github.com/croaky/recipient_interceptor) to
  avoid accidentally sending emails to real people from staging
* [Simple Form](https://github.com/plataformatec/simple_form) for form markup
  and style
* [Unicorn](https://github.com/defunkt/unicorn) to serve HTTP requests

And gems only for staging and production like:

* [New Relic RPM](https://github.com/newrelic/rpm) for monitoring performance
* [Rails 12 Factor](https://github.com/heroku/rails_12factor) to making running
  Rails 4 apps easier on Heroku

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

Other goodies
-------------

Suspenders also comes with:

* The [`./bin/setup`][bin] convention for new developer setup
* Rails' flashes set up and in application layout
* A few nice time formats set up for localization
* `Rack::Deflater` to [compress responses with Gzip][compress]
* [Fast-failing factories][fast]

[bin]: http://robots.thoughtbot.com/bin-setup
[compress]: http://robots.thoughtbot.com/content-compression-with-rack-deflater/
[fast]: http://robots.thoughtbot.com/testing-your-factories-first

Suspenders fixes several of Rails' [insecure defaults]:

* Suspenders uses Unicorn instead of WEBrick, allowing less verbose Server
  headers.
* Suspenders is configured to pull your application secret key base from an
  environment variable, which means you won't need to risk placing it in version
  control.

[insecure defaults]: http://blog.codeclimate.com/blog/2013/03/27/rails-insecure-defaults/

Heroku
------

You can optionally create Heroku staging and production apps:

    suspenders app --heroku true

This:

* Creates a staging and production Heroku app
* Sets them as `staging` and `production` Git remotes
* Configures staging with `RACK_ENV` and `RAILS_ENV` environment variables set
  to `staging`

Git
---

This will initialize a new git repository for your Rails app. You can
bypass this with the `--skip-git` option:

    suspenders app --skip-git true

GitHub
------

You can optionally create a GitHub repository for the suspended Rails app. It
requires that you have [Hub](https://github.com/github/hub) on your system:

    curl http://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub
    suspenders app --github organization/project

This has the same effect as running:

    hub create organization/project

Dependencies
------------

Suspenders requires Ruby 1.9.2 or greater.

Some gems included in Suspenders have native extensions. You should have GCC
installed on your machine before generating an app with Suspenders.

Use [OS X GCC Installer](https://github.com/kennethreitz/osx-gcc-installer/) for
Snow Leopard (OS X 10.6).

Use [Command Line Tools for XCode](https://developer.apple.com/downloads/index.action)
for Lion (OS X 10.7) or Mountain Lion (OS X 10.8).

We use [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit) for
full-stack Javascript integration testing. It requires QT. Instructions for
installing QT are
[here](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit).

PostgreSQL needs to be installed and running for the `db:create` rake task.

Issues
------

If you have problems, please create a
[Github Issue](https://github.com/thoughtbot/suspenders/issues).

Contributing
------------

Please see CONTRIBUTING.md for details.

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Suspenders is maintained and funded by
[thoughtbot, inc](http://thoughtbot.com/community).

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

Suspenders is Copyright © 2008-2014 thoughtbot. It is free software, and may be
redistributed under the terms specified in the LICENSE file.
