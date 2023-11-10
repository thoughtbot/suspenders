# Suspenders

Suspenders is a Rails plugin containing generators for configuring Rails
applications. It is used by thoughtbot to get a jump start on a new or existing
app. Use Suspenders if you're in a rush to build something amazing; don't use it
if you like missing deadlines.

![Suspenders boy](http://media.tumblr.com/1TEAMALpseh5xzf0Jt6bcwSMo1_400.png)

## Usage

```
group :development, :test do
  gem "suspenders"
end
```

```
bin/rails g suspenders:all
```

## Generators

### Accessibility

Installs [capybara_accessibility_audit] and [capybara_accessible_selectors]

`bin/rails g suspenders:accessibility`

  [capybara_accessibility_audit]: https://github.com/thoughtbot/capybara_accessibility_audit
  [capybara_accessible_selectors]: https://github.com/citizensadvice/capybara_accessible_selectors

### Advisories

Show security advisories during development.

Uses the [bundler-audit][] gem to update the local security database and
show any relevant issues with the app's dependencies. This generator is
only responsible for installing the gem and adding the Rake task.

`bin/rails g suspenders:advisories`

  [bundler-audit]: https://github.com/rubysec/bundler-audit

### Factories

Build test data with clarity and ease.

This uses [FactoryBot] to help you define dummy and test data for your
test suite. The `create`, `build`, and `build_stubbed` class methods are
directly available to all tests.

We recommend putting FactoryBot definitions in one `spec/factories.rb`
(or `test/factories`) file, at least until it grows unwieldy. This helps reduce
confusion around circular dependencies and makes it easy to jump between
definitions.

Supports the [default test suite] and [RSpec].

`bin/rails g suspenders:factories`

  [Factory Bot]: https://github.com/thoughtbot/factory_bot_rails
  [default test suite]: https://guides.rubyonrails.org/testing.html
  [RSpec]: https://rspec.info

### Inline SVG

Render SVG images inline using the [inline_svg] gem, as a potential performance
improvement for the viewer.

`bin/rails g suspenders:inline_svg`

  [inline_svg]: https://github.com/jamesmartin/inline_svg

### Lint

Creates a holistic linting solution that covers JavaScript, CSS, Ruby and ERB.

Introduces NPM commands that leverage [@thoughtbot/eslint-config][],
[@thoughtbot/stylelint-config][] and [prettier][].

Also introduces `.prettierrc` based off of our [Guides][].

Introduces `rake standard` which also runs `erblint` to lint ERB files
via [better_html][], [erb_lint][] and [erblint-github][].

[@thoughtbot/eslint-config]: https://github.com/thoughtbot/eslint-config
[@thoughtbot/stylelint-config]: https://github.com/thoughtbot/stylelint-config
[prettier]: https://prettier.io
[Guides]: https://github.com/thoughtbot/guides/blob/main/javascript/README.md#formatting
[better_html]: https://github.com/Shopify/better-html
[erb_lint]: https://github.com/Shopify/erb-lint
[erblint-github]: https://github.com/github/erblint-github

### Styles

Configures applications to use [PostCSS][] or [Tailwind][] via
[cssbundling-rails][]. Defaults to PostCSS with [modern-normalize][], with the
option to override via `--css=tailwind`.

Also creates additional stylesheets if using PostCSS.

`bin/rails g suspenders:styles --css[postcss:tailwind]`

  [PostCSS]: https://postcss.org
  [Tailwind]: https://tailwindcss.com
  [cssbundling-rails]: https://github.com/rails/cssbundling-rails
  [modern-normalize]: https://github.com/sindresorhus/modern-normalize


### Jobs

Installs [Sidekiq][] for background job processing and configures ActiveJob for job queueing.

`bin/rails g suspenders:jobs`

  [Sidekiq]: https://github.com/sidekiq/sidekiq

### Rake

Configures the default Rake task to audit and lint the codebase with
[bundler-audit][] and [standard][] in addition to running the test suite.

`bin/rails g suspenders:rake`

  [bundler-audit]: https://github.com/rubysec/bundler-audit
  [standard]: https://github.com/standardrb/standard

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

## About

Suspenders is maintained by [thoughtbot].

![thoughtbot](https://thoughtbot.com/brand_assets/93:44.svg)

Suspenders is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community]
or [hire us][hire] to help build your product.

  [community]: https://thoughtbot.com/community?utm_source=github
  [hire]: https://thoughtbot.com/hire-us?utm_source=github
