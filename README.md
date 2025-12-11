# Suspenders

[![CI](https://github.com/thoughtbot/suspenders/actions/workflows/main.yml/badge.svg)](https://github.com/thoughtbot/suspenders/actions/workflows/main.yml)

Suspenders is intended to create a new Rails applications with these
[features][], and is optimised for deployment to Heroku. 

It is used by thoughtbot to get a jump start on new apps. Use Suspenders if
you're in a rush to build something amazing; don't use it if you like missing
deadlines.

[features]: ./FEATURES.md

![Suspenders boy](https://media.tumblr.com/1TEAMALpseh5xzf0Jt6bcwSMo1_400.png)

## Requirements

Suspenders requires the latest version of [Rails][rails] and its dependencies.

Additionally, Suspenders requires [yarn][yarn], [PostgreSQL][postgresql] and
[Redis][redis].

[rails]: https://guides.rubyonrails.org/install_ruby_on_rails.html
[yarn]: https://yarnpkg.com/getting-started/install
[postgresql]: https://formulae.brew.sh/formula/postgresql@17
[redis]: https://formulae.brew.sh/formula/redis

## Installation

```
gem install suspenders
```

## Usage

```
suspenders <app_name>
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
PostgreSQL][] as our database. We skip the Solid ecosystm since we prefer
[Sidekiq][], and because Solid Queue has [performance issues][] on Heroku.

[application template]: https://guides.rubyonrails.org/rails_application_templates.html
[default test framework]: https://guides.rubyonrails.org/testing.html
[RSpec]: http://rspec.info
[prefer PostgreSQL]: https://github.com/thoughtbot/dotfiles/pull/728
[Sidekiq]: https://github.com/sidekiq/sidekiq/
[performance issues]: https://github.com/rails/solid_queue/issues/330

### Available Tasks

Suspenders ships with several custom Rake tasks.

```
bin/rails suspenders:rake
bin/rails suspenders:db:migrate
bin/rails suspenders:cleanup:organize_gemfile
```

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
