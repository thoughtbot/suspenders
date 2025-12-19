# Suspenders

[![CI](https://github.com/thoughtbot/suspenders/actions/workflows/test-template.yml/badge.svg)](https://github.com/thoughtbot/suspenders/actions/workflows/test-template.yml)

Suspenders is intended to create a new Rails applications with these
[features][], and is optimized for deployment on Heroku.

It is used by thoughtbot to get a jump start on new apps. Use Suspenders if
you're in a rush to build something amazing; don't use it if you like missing
deadlines.

[features]: ./FEATURES.md

![Suspenders boy](https://media.tumblr.com/1TEAMALpseh5xzf0Jt6bcwSMo1_400.png)

## Prerequisites 

Suspenders requires the **latest** version of [Rails][] and its dependencies.

Additionally, Suspenders requires [PostgreSQL][] and [Redis][].

[Rails]: https://guides.rubyonrails.org/install_ruby_on_rails.html
[PostgreSQL]: https://formulae.brew.sh/formula/postgresql@17
[Redis]: https://formulae.brew.sh/formula/redis

## Installation

```
gem install suspenders
```

## Usage

First, make sure you're on the latest version of Rails.

```
gem update rails
```

Then, create a new application with Suspenders.

```
suspenders new <app_name>
```

Under the hood, Suspenders uses an [application template][] to generate a new Rails
application like so:

```
rails new <app_name> \
 -d=postgresql \
 --skip-test \
 --skip-solid \
 --m=~/path/to/template.rb
```

We skip the [default test framework][] in favor of [RSpec][], and [prefer
PostgreSQL][] as our database. We skip the Solid ecosystem since we prefer
[Sidekiq][], and because Solid Queue has [performance issues][] on Heroku.

> [!IMPORTANT]
> Since Suspenders generates an application that enables `require_master_key`,
> you'll need to add it to GitHub as a [secret][] in order for GitHub Actions to
> work.

```
cd <app_name>

gh secret set RAILS_MASTER_KEY value-from-config-master.key
```

[application template]: https://guides.rubyonrails.org/rails_application_templates.html
[default test framework]: https://guides.rubyonrails.org/testing.html
[RSpec]: http://rspec.info
[prefer PostgreSQL]: https://github.com/thoughtbot/dotfiles/pull/728
[Sidekiq]: https://github.com/sidekiq/sidekiq/
[performance issues]: https://github.com/rails/solid_queue/issues/330
[secret]: https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets

## Initial deployment to Heroku

Once your application is generated, you can deploy to Heroku with [Heroku CLI][cli].


```
cd <app_name>

heroku apps:create

heroku buildpacks:set heroku/ruby

heroku addons:create heroku-postgresql:essential-0
heroku addons:create heroku-redis:mini
```

Once the application is provisioned, you'll want to set the following required
environment variables.

```
heroku config:set \
 APPLICATION_HOST=value-from-heroku
 RAILS_MASTER_KEY=value-from-config-master.key
```

Finally, don't forget to enable the `worker`.

```
heroku ps:scale worker=1
```

[cli]: https://devcenter.heroku.com/articles/heroku-cli

## Contributing

See the [CONTRIBUTING] document.
Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/thoughtbot/suspenders/graphs/contributors

## License

Suspenders is Copyright (c) thoughtbot, inc.
It is free software, and may be redistributed
under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

<!-- START /templates/footer.md -->
## About thoughtbot

![thoughtbot](https://thoughtbot.com/thoughtbot-logo-for-readmes.svg)

This repo is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community].
We are [available for hire][hire].

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github


<!-- END /templates/footer.md -->
