# Features

## Local Development

### Seed Data

- Use `db/seeds.rb` to create records that need to exist in all environments.
- Use `lib/tasks/dev.rake` to create records that only need to exist in development.

Running `bin/setup` will run `dev:prime`.

### Tasks

- Use `bin/rails suspenders:db:migrate` to run [database migrations][]. This script ensures they are [reversible][].
- Use `bin/rails suspenders:cleanup:organize_gemfile` to automatically organize the project's Gemfile.
- Use `bin/rails default` to run the default Rake task. This will do the following:
  - Run the test suite.
  - Run a Ruby and ERB linter.
  - Scan the Ruby codebase for any dependency vulnerabilities.

[database migrations]: https://edgeguides.rubyonrails.org/active_record_migrations.html#running-migrations
[reversible]: https://edgeguides.rubyonrails.org/active_record_migrations.html#making-the-irreversible-possible

## Configuration

### Test

- Enables [raise_on_missing_translations][].
- Disables [action_dispatch.show_exceptions][].

[raise_on_missing_translations]: https://guides.rubyonrails.org/configuring.html#config-i18n-raise-on-missing-translations
[action_dispatch.show_exceptions]: https://edgeguides.rubyonrails.org/configuring.html#config-action-dispatch-show-exceptions

### Development

- Enables [raise_on_missing_translations][].
- Enables [annotate_rendered_view_with_filenames][].
- Enables [i18n_customize_full_message][].
- Enables [query_log_tags_enabled][].

[raise_on_missing_translations]: https://guides.rubyonrails.org/configuring.html#config-i18n-raise-on-missing-translations
[annotate_rendered_view_with_filenames]: https://guides.rubyonrails.org/configuring.html#config-action-view-annotate-rendered-view-with-filenames
[i18n_customize_full_message]: https://guides.rubyonrails.org/configuring.html#config-active-model-i18n-customize-full-message
[query_log_tags_enabled]: https://guides.rubyonrails.org/configuring.html#config-active-record-query-log-tags-enabled

### Production

- Enables [require_master_key][].

[require_master_key]: https://guides.rubyonrails.org/configuring.html#config-require-master-key

### Linting

- Uses [@thoughtbot/eslint-config][] for JavaScript linting.
- Uses [@thoughtbot/stylelint-config][] for CSS linting.
- Uses [prettier][] for additional linting.
- Uses [better_html][], [erb_lint][], and [erblint-github][] for ERB linting.
- Uses [standard][] for Ruby linting.

**Available Commands**

- Run `yarn lint` to lint front-end code.
- Run `yarn fix:prettier` to automatically fix prettier violations.
- Run `bin/rails standard` to lint ERB and Ruby code.
- Run `bundle exec standardrb --fix` to fix standard violations.

[@thoughtbot/eslint-config]: https://github.com/thoughtbot/eslint-config
[@thoughtbot/stylelint-config]: https://github.com/thoughtbot/stylelint-config
[prettier]: https://prettier.io
[better_html]: https://github.com/Shopify/better-html
[erb_lint]: https://github.com/Shopify/erb-lint
[erblint-github]: https://github.com/github/erblint-github
[standard]: https://github.com/standardrb/standard

## Testing

Uses [RSpec][] and [RSpec Rails][] in favor of the [default test suite][].

The test suite can be run with `bin/rails spec`.

Configuration can be found in the following files:

```
spec/rails_helper.rb
spec/spec_helper.rb
spec/support/action_mailer.rb
spec/support/driver.rb
spec/support/i18n.rb
spec/support/shoulda_matchers.rb
```

- Uses [action_dispatch-testing-integration-capybara][] to introduce Capybara assertions into Request specs.
- Uses [shoulda-matchers][] for simple one-liner tests for common Rails functionality.
- Uses [webmock][] for stubbing and setting expectations on HTTP requests in Ruby.

[RSpec]: http://rspec.info
[RSpec Rails]: https://github.com/rspec/rspec-rails
[default test suite]: https://guides.rubyonrails.org/testing.html
[action_dispatch-testing-integration-capybara]: https://github.com/thoughtbot/action_dispatch-testing-integration-capybara
[shoulda-matchers]: https://github.com/thoughtbot/shoulda-matchers
[webmock]: https://github.com/bblimke/webmock

### Factories

Uses [FactoryBot][] as an alternative to [Fixtures][] to help you define
dummy and test data for your test suite. The `create`, `build`, and
`build_stubbed` class methods are directly available to all tests.

Place FactoryBot definitions in `spec/factories.rb`, at least until it
grows unwieldy. This helps reduce confusion around circular dependencies and
makes it easy to jump between definitions.

[FactoryBot]: https://github.com/thoughtbot/factory_bot
[Fixtures]: https://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures

## Accessibility

Uses [capybara_accessibility_audit][] and
[capybara_accessible_selectors][] to encourage and enforce accessibility best
practices.

[capybara_accessibility_audit]: https://github.com/thoughtbot/capybara_accessibility_audit
[capybara_accessible_selectors]: https://github.com/citizensadvice/capybara_accessible_selectors

## Advisories

Uses [bundler-audit][] to update the local security database and show
any relevant issues with the app's dependencies via a Rake task.

[bundler-audit]: https://github.com/rubysec/bundler-audit

## Mailers

[Intercept][] emails in non-production environments by setting `INTERCEPTOR_ADDRESSES`.

```sh
INTERCEPTOR_ADDRESSES="user_1@example.com,user_2@example.com" bin/rails s
```

Configuration can be found at `config/initializers/email_interceptor.rb`.

Interceptor can be found at `app/mailers/email_interceptor.rb`.

[Intercept]: https://guides.rubyonrails.org/action_mailer_basics.html#intercepting-emails

## Jobs

Uses [Sidekiq][] for [background job][] processing.

Configures the `test` environment to use the [inline][] adapter.

[Sidekiq]: https://github.com/sidekiq/sidekiq
[background job]: https://guides.rubyonrails.org/active_job_basics.html
[inline]: https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters/InlineAdapter.html

## Layout and Assets

### Stylesheets

- Uses [PostCSS][] via [cssbundling-rails][].
- Uses [modern-normalize][] to normalize browsers' default style.

Configuration can be found at `postcss.config.js`.

Adds the following stylesheet structure.

```
app/assets/stylesheets/base.css
app/assets/stylesheets/components.css
app/assets/stylesheets/utilities.css
```

Adds `app/assets/static` so that [postcss-url][] has a directory to copy
assets to.

[PostCSS]: https://postcss.org
[cssbundling-rails]: https://github.com/rails/cssbundling-rails
[modern-normalize]: https://github.com/sindresorhus/modern-normalize
[postcss-url]: https://github.com/postcss/postcss-url

### Inline SVG

Uses [inline_svg][] for embedding SVG documents into views.

Configuration can be found at `config/initializers/inline_svg.rb`

[inline_svg]: https://github.com/jamesmartin/inline_svg

### Layout

- A [partial][] for [flash messages][] is located in `app/views/application/_flashes.html.erb`.
- Sets [lang][] attribute on `<html>` element to `en` via `I18n.local`.
- Dynamically sets `<title>` via the [title][] gem.
- Disables Turbo's [Prefetch][] in an effort to reduce unnecessary network requests.

[partial]: https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials
[flash messages]: https://guides.rubyonrails.org/action_controller_overview.html#the-flash
[lang]: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/lang
[title]: https://github.com/calebhearth/title
[Prefetch]: https://turbo.hotwired.dev/handbook/drive#prefetching-links-on-hover
