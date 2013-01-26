# Suspenders [![Build Status](https://secure.travis-ci.org/thoughtbot/suspenders.png?branch=master)](http://travis-ci.org/thoughtbot/suspenders)

Suspenders is the base Rails application used at [thoughtbot](http://thoughtbot.com/community).

  ![Suspenders boy](http://media.tumblr.com/1TEAMALpseh5xzf0Jt6bcwSMo1_400.png)

Installation
------------

First install the suspenders gem:

    gem install suspenders

Then run:

    suspenders projectname

This will create a Rails 3.2 app in `projectname`. This script creates a
new git repository. It is not meant to be used against an existing repo.

Gemfile
-------

To see the latest and greatest gems, look at Suspenders'
[template/Gemfile_clean](/thoughtbot/suspenders/blob/master/templates/Gemfile_clean),
which will be appended to the default generated projectname/Gemfile.

It includes application gems like:

* [Airbrake](/airbrake/airbrake) for exception notification
* [Bourbon](/thoughtbot/bourbon) for Sass mixins
* [Simple Form](/plataformatec/simple_form) for form markup and style

And testing gems like:

* [Bourne](/thoughtbot/bourne) and [Mocha](/freerange/mocha) for stubbing and
  spying
* [Capybara](/jnicklas/capybara) and
  [Capybara Webkit](/thoughtbot/capybara-webkit) for integration testing
* [Factory Girl](/thoughtbot/factory_girl) for test data
* [RSpec](https://github.com/rspec/rspec) for unit testing
* [Shoulda Matchers](/thoughtbot/shoulda-matchers) for common RSpec matchers
* [Timecop](/jtrupiano/timecop) for testing time

Other goodies
-------------

Suspenders also comes with:

* Override recipient emails in staging environment.
* Rails' flashes set up and in application layout.
* A few nice time formats set up for localization.
* [Heroku-recommended asset pipeline
  settings](https://devcenter.heroku.com/articles/rails3x-asset-pipeline-cedar/).

Heroku
------

You can optionally create Heroku staging and production apps:

    suspenders app --heroku true

This has the same effect as running:

    heroku create app-staging --remote staging
    heroku create app-production --remote production

Github
------

You can optionally create a Github repository:

    suspenders app --github organization/project

This has the same effect as running:

    hub create organization/project

Dependencies
------------

Some gems included in Suspenders have native extensions. You should have GCC installed on your
machine before generating an app with Suspenders.

Use [OS X GCC Installer](/kennethreitz/osx-gcc-installer/) for Snow Leopard
(OS X 10.6).

Use [Command Line Tools for XCode](https://developer.apple.com/downloads/index.action)
for Lion (OS X 10.7) or Mountain Lion (OS X 10.8).

We use [Capybara Webkit](/thoughtbot/capybara-webkit) for full-stack Javascript
integration testing. It requires QT. Instructions for installing QT are
[here](/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit).

PostgreSQL needs to be installed and running for the `db:create` rake task.

Issues
------

If you have problems, please create a [Github Issue](/thoughtbot/suspenders/issues).

Contributing
------------

Please see CONTRIBUTING.md for details.

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Suspenders is maintained and funded by [thoughtbot, inc](http://thoughtbot.com/community)

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

License
-------

Suspenders is Copyright © 2008-2013 thoughtbot. It is free software, and may be
redistributed under the terms specified in the LICENSE file.
