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

### Inline SVG

Render SVG images inline using the [inline_svg] gem, as a potential performance
improvement for the viewer.

`bin/rails g suspenders:inline_svg`

  [inline_svg]: https://github.com/jamesmartin/inline_svg

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
