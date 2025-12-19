# Features

## Local Development

### Strong Migrations

Uses [Strong Migrations][] to catch unsafe migrations in development.

[Strong Migrations]: https://github.com/ankane/strong_migrations

### Seed Data

Follows [our guidance][seed-data-guide] for managing seed data. Use
`db/seeds.rb` for data required in **all** environments, and
`development:db:seed` for data specific to development environments.

Place idempotent seed data in `Development::Seeder`.

To load development seed data:

```bash
bin/rails development:db:seed
```

To reset your database and reload seed data:

```bash
bin/rails development:db:seed:replant
```

The `replant` command truncates all tables and reloads the seed data, providing
a clean slate for development.

[seed-data-guide]: https://github.com/thoughtbot/guides/blob/main/rails/how-to/seed-data.md

## Environment Variables

The following environment variables are available in `production`:

- `APPLICATION_HOST` - The domain where your application is hosted (required)
- `ASSET_HOST` - CDN or asset host URL (optional)
- `RAILS_MASTER_KEY` - Used for decrypting credentials (required)

## Configuration

### All Environments

- Enables [strict_loading_by_default][].
- Sets [strict_loading_mode][] to `:n_plus_one`.
- Enables [require_master_key][].

[strict_loading_by_default]: https://guides.rubyonrails.org/configuring.html#config-active-record-strict-loading-by-default
[strict_loading_mode]: https://guides.rubyonrails.org/configuring.html#config-active-record-strict-loading-mode
[require_master_key]: https://guides.rubyonrails.org/configuring.html#config-require-master-key

### Test

- Enables [raise_on_missing_translations][].
- Sets [action_dispatch.show_exceptions][] to `:none`.

[raise_on_missing_translations]: https://guides.rubyonrails.org/configuring.html#config-i18n-raise-on-missing-translations
[action_dispatch.show_exceptions]: https://edgeguides.rubyonrails.org/configuring.html#config-action-dispatch-show-exceptions

### Development

- Enables [raise_on_missing_translations][].
- Enables [i18n_customize_full_message][].
- Enables [apply_rubocop_autocorrect_after_generate!][].

[raise_on_missing_translations]: https://guides.rubyonrails.org/configuring.html#config-i18n-raise-on-missing-translations
[i18n_customize_full_message]: https://guides.rubyonrails.org/configuring.html#config-active-model-i18n-customize-full-message
[apply_rubocop_autocorrect_after_generate!]: https://guides.rubyonrails.org/configuring.html#configuring-generators

### Production

- Enables [sandbox_by_default][].
- Sets [action_on_strict_loading_violation][] to `:log`.

[sandbox_by_default]: https://guides.rubyonrails.org/configuring.html#config-sandbox-by-default
[action_on_strict_loading_violation]: https://guides.rubyonrails.org/configuring.html#config-active-record-action-on-strict-loading-violation

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

## Mailers

[Intercept][] emails in non-production environments by setting `INTERCEPTOR_ADDRESSES`.

```sh
INTERCEPTOR_ADDRESSES="user_1@example.com,user_2@example.com" bin/rails s
```

Configuration can be found at `config/initializers/email_interceptor.rb`.

Interceptor can be found at `lib/email_interceptor.rb`.

[Intercept]: https://guides.rubyonrails.org/action_mailer_basics.html#intercepting-emails

## Jobs

Uses [Sidekiq][] for [background job][] processing.

Configures the `test` environment to use the [inline][] adapter.

[Sidekiq]: https://github.com/sidekiq/sidekiq
[background job]: https://guides.rubyonrails.org/active_job_basics.html
[inline]: https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters/InlineAdapter.html

## Layout and Assets

### Inline SVG

Uses [inline_svg][] for embedding SVG documents into views.

Configuration can be found at `config/initializers/inline_svg.rb`

[inline_svg]: https://github.com/jamesmartin/inline_svg

### Layout

- A [partial][] for [flash messages][] is located in `app/views/application/_flashes.html.erb`.
- A [partial][] for form errors is located in `app/views/application/_form_errors.html.erb`.
- Sets [lang][] attribute on `<html>` element to `en` via `I18n.local`.
- Disables Turbo's [Prefetch][] in an effort to reduce unnecessary network requests.

[partial]: https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials
[flash messages]: https://guides.rubyonrails.org/action_controller_overview.html#the-flash
[lang]: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/lang
[title]: https://github.com/calebhearth/title
[Prefetch]: https://turbo.hotwired.dev/handbook/drive#prefetching-links-on-hover
