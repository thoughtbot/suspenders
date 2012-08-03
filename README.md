# Suspenders [![Build Status](https://secure.travis-ci.org/thoughtbot/suspenders.png?branch=master)](http://travis-ci.org/thoughtbot/suspenders)

Suspenders is the base Rails application used at [thoughtbot](http://thoughtbot.com/community).

  ![Suspenders boy](http://media.tumblr.com/1TEAMALpseh5xzf0Jt6bcwSMo1_400.png)

Installation
------------

First install the suspenders gem:

    gem install suspenders

Then run:

    suspenders projectname

This will create a Rails 3.1 app in `projectname`. This script creates a new
new git repository. It is not meant to be used against an existing repo.

Gemfile
-------

To see the latest and greatest gems, look at Suspenders'
[template/Gemfile_additions](https://github.com/thoughtbot/suspenders/blob/master/templates/Gemfile_additions),
which will be appended to the default generated projectname/Gemfile.

It includes application gems like:

* [Airbrake](https://github.com/airbrake/airbrake) for exception notification
* [Bourbon](https://github.com/thoughtbot/bourbon) for classy sass mixins
* [Clearance](https://github.com/thoughtbot/clearance) for authentication
* [Flutie](https://github.com/thoughtbot/flutie) for default CSS styles
* [Formtastic](https://github.com/justinfrench/formtastic) for better forms
* [Paperclip](https://github.com/thoughtbot/paperclip) for file uploads

And testing gems like:

* [Bourne](https://github.com/thoughtbot/bourne) and Mocha for stubbing and spying
* [Cucumber, Capybara, and Capybara Webkit](http://robots.thoughtbot.com/post/4583605733/capybara-webkit) for integration testing, including Javascript behavior
* [Factory Girl](https://github.com/thoughtbot/factory_girl) for easier creation of test data
* [RSpec](https://github.com/rspec/rspec) for awesome, readable isolation testing
* [Shoulda Matchers](http://github.com/thoughtbot/shoulda-matchers) for frequently needed Rails and RSpec matchers
* [Timecop](https://github.com/jtrupiano/timecop) for dealing with time

Other goodies
-------------

Suspenders also comes with:

* Rails' flashes set up and in application layout.
* A few nice time formats.

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

Clearance
---------

You can optionally not include Clearance:

    suspenders app --clearance false

Capybara Webkit
---------------

You can optionally not include Capybara Webkit (which depends on QT being
installed on your machine):

    suspenders app --webkit false

Dependencies
------------

Some gems included in Suspenders have native extensions. You should have GCC installed on your
machine before generating an app with Suspenders.

If you're running OS X, we recommend the [GCC OSX installer](https://github.com/kennethreitz/osx-gcc-installer).

We use [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit) for full-stack Javascript integration testing.
It requires you have QT installed on your machine before running Suspenders.

Instructions for installing QT on most systems are [available here](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit).

PostgreSQL needs to be installed and running for the `db:create` rake task.

Issues
------

If you have problems, please create a [Github issue](https://github.com/thoughtbot/suspenders/issues).

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

Suspenders is Copyright © 2008-2011 thoughtbot. It is free software, and may be redistributed under the terms specified in the LICENSE file.
