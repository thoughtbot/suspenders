# Suspenders

[![CI](https://github.com/thoughtbot/suspenders/actions/workflows/main.yml/badge.svg)](https://github.com/thoughtbot/suspenders/actions/workflows/main.yml)

Suspenders is a [Rails Engine][] containing generators for configuring Rails
applications with these [features][].

It is used by thoughtbot to get a jump start on a new or existing app. Use
Suspenders if you're in a rush to build something amazing; don't use it if you
like missing deadlines.

[Rails Engine]: https://guides.rubyonrails.org/engines.html
[features]: ./FEATURES.md

![Suspenders boy](https://media.tumblr.com/1TEAMALpseh5xzf0Jt6bcwSMo1_400.png)

## Requirements

- Rails `~> 8.0`
- Ruby `>= 3.1`
- Node `>= 20.0.0`

## Usage

Suspenders can be used to create a new Rails application, or to enhance an
existing Rails application.

### With New Rails Applications

This approach uses an [application template][] to generate a new Rails
application with Suspenders.

We skip the [default test framework][] in favor of [RSpec][], and [prefer
PostgreSQL][] as our database.

We skip [RuboCop rules by default][] in favor of our [holistic linting rules][].

#### Use the latest suspenders release:

```
rails new app_name \
 --skip-rubocop \
 --skip-test \
 -d=postgresql \
 -m=https://raw.githubusercontent.com/thoughtbot/suspenders/main/lib/install/web.rb
```

#### OR use the current (possibly unreleased) `main` branch of suspenders:

```
rails new app_name \
 --suspenders-main \
 --skip-rubocop \
 --skip-test \
 -d=postgresql \
 -m=https://raw.githubusercontent.com/thoughtbot/suspenders/main/lib/install/web.rb
```

Then run `bin/setup` within the newly generated application.

Alternatively, if you're using our [dotfiles][], then you can just run `rails new
app_name`, or create your own [railsrc][] file with the following configuration:

```
--skip-rubocop
--skip-test
--database=postgresql
-m=https://raw.githubusercontent.com/thoughtbot/suspenders/main/lib/install/web.rb
```

[application template]: https://guides.rubyonrails.org/rails_application_templates.html
[default test framework]: https://guides.rubyonrails.org/testing.html
[RSpec]: http://rspec.info
[prefer PostgreSQL]: https://github.com/thoughtbot/dotfiles/pull/728
[dotfiles]: https://github.com/thoughtbot/dotfiles
[railsrc]: https://github.com/rails/rails/blob/7f7f9df8641e35a076fe26bd097f6a1b22cb4e2d/railties/lib/rails/generators/rails/app/USAGE#L5C1-L7
[RuboCop rules by default]: https://guides.rubyonrails.org/v7.2/7_2_release_notes.html#add-omakase-rubocop-rules-by-default
[holistic linting rules]: https://github.com/thoughtbot/suspenders/blob/main/FEATURES.md#linting

### With Existing Rails Applications

Suspenders can be used on an existing Rails application by adding it to the
`:development` and `:test` group.

```ruby
group :development, :test do
  gem "suspenders"
end
```

Once installed, you can invoke the web installation generator, which will
invoke all generators.

```
bin/rails g suspenders:install:web
```

Or, you can invoke generators individually. To see a list of available
generators run:

```
bin/rails g | grep suspenders
```

To learn more about a generator, run:

```
bin/rails g suspenders:[generator_name] --help
```

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
