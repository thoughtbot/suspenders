# Contributing

## Accessibility Tooling

Building accessible applications is a complex, multi-faceted, and mission critical endeavor. While tooling cannot guarantee an accessible experience, it can help raise the bar for the baseline experience in important ways.

In addition to the W3C's [WAI Overview][], [WAI Authoring Practices Guide][], and [WAI-ARIA Specification][], along with MDN's [Accessibility Documentation][], the [thoughtbot handbook][] includes some high-level technical guidance.

[WAI Overview]: https://www.w3.org/WAI/standards-guidelines/aria/
[WAI Authoring Practices Guide]: https://www.w3.org/WAI/ARIA/apg/
[WAI-ARIA Specification]: https://www.w3.org/TR/wai-aria/
[Accessibility Documentation]: https://developer.mozilla.org/en-US/docs/Web/Accessibility
[thoughtbot guides]: https://github.com/thoughtbot/guides/blob/main/accessibility/README.md#development

### Capybara and the System Test Suite

[Capybara][] is responsible for driving the application's [System Test][] suite through Real Life browser sessions.

Capybara drives the page and makes assertions about its state and content through utilities called [Selectors][]. They're a layer of abstraction that's a blend of HTML tag names and ARIA role semantics. For example, Capybara uses the `:link` selector whether it needs to locate and click on an `<a>` element through a call to [click_link][] or make an assertion about the presence and content of an `<a>` element through a call to [assert_link][].

Out of the box, Capybara provides a wide range of [built-in selectors][] that cover the majority of a System Test harness' needs. In addition to the out of the box selectors, this project also depends on the [capybara_accessible_selectors][] gem to expand Capybara's set of selectors.

If you find yourself in a situation where you're reaching for CSS selectors or other means of resolving nodes, you might benefit from a built-in selector or one provided by `capybara_accessible_selectors`. Take this test block, for example:

```ruby
# <fieldset class="some-css selector-chain">
#   <legend>Some fields</legend>
#
#   <button class="my-button">Click me</button>
#
#   <label>
#     Fill me in
#     <input class=".my-text-field">
#   </label>
# </fieldset>

# BEFORE
within ".some-css .selector-chain" do
  find(".my-button").click
  find(".my-text-field").set "Hello, world"
end

# AFTER
within :fieldset, "Some field" do
  click_button "Click me"
  fill_in "Fill me in", with: "Hello, world"
end
```

The [Testing RSpec][] section of the `thoughtbot/guides` provides some general guidance for automated Acceptance Testing.

[Capybara]: https://rubydoc.info/github/teamcapybara/capybara/master/
[System Test]: https://guides.rubyonrails.org/testing.html#system-testing
[Selectors]: https://rubydoc.info/github/teamcapybara/capybara/master#selectors
[click_link]: https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Node/Actions:click_link
[assert_link]: https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Minitest/Assertions:assert_link
[built-in selectors]: https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Selector#built-in-selectors
[capybara_accessible_selectors]: https://github.com/citizensadvice/capybara_accessible_selectors
[Testing RSpec]: https://github.com/thoughtbot/guides/blob/main/testing-rspec/README.md#acceptance-tests

### `capybara_accessibility_audit` and `axe.js`

This project depends on the [capybara_accessibility_audit][] gem to enhance the application's System Test suite to audit the browser's DOM for statically detectable accessibility violations. Under the hood, `capybara_accessibility_audit` utilizes [axe.js][] for auditing.

The categories of violation that `capybara_accessibility_audit` can detect span a wide range from insufficient [color contrast][] to invalid or insufficient [landmark-based information hierarchy][landmark], to [unnamed form controls][] and beyond.

Out of the box, `capybara_accessibility_audit` will extend Capybara to conduct an accessibility audit after a variety of actions like `visit` and `click_link`. That project can [be configured to suit this application's needs][capybara_accessibility_audit-configuration].

If you can integrate `capybara_accessibility_audit` from the project's inception, you can start with (and maintain!) accessibility violation bankruptcy.

[capybara_accessibility_audit]: https://github.com/thoughtbot/capybara_accessibility_audit
[capybara_accessibility_audit-configuration]: https://github.com/thoughtbot/capybara_accessibility_audit?tab=readme-ov-file#frequently-asked-questions
[axe.js]: https://www.deque.com/axe/
[color contrast]: https://developer.mozilla.org/en-US/docs/Web/Accessibility/Understanding_WCAG/Perceivable/Color_contrast
[landmark]: https://developer.mozilla.org/en-US/blog/aria-accessibility-html-landmark-roles/
[unnamed form controls]: https://developer.mozilla.org/en-US/docs/Web/Accessibility/Understanding_WCAG/Text_labels_and_names#form_elements_must_be_labeled

### VoiceOver on macos

VoiceOver is a screen reader integrated directly into the macOS operating system. You can learn more from [Apple's Accessibility Support][].

VoiceOver and Safari are tightly integrated. If you're developing this
application on a Mac, you should familiarize yourself with how to navigate in
Safari using VoiceOver. You can learn more about how to use VoiceOver from the
[Get started with VoiceOver on Mac][]. You might also enjoy [Screen Reader
Basics: VoiceOver][] in the A11ycasts series of videos from the "Chrome for Developers" YouTube channel.

[![Watch Screen Reader Basics: VoiceOver](https://img.youtube.com/vi/5R-6WvAihms/maxresdefault.jpg)](https://www.youtube.com/watch?v=5R-6WvAihms)

After you've written a System Test or have completed a feature, it can be **extremely** valuable to navigate to that part of the application and try your best to recreate the experience based on keyboard navigation and screen reader announcements alone.

[Apple's Accessibility Support]: https://support.apple.com/accessibility
[Get started with VoiceOver on Mac]: https://support.apple.com/guide/voiceover/get-started-vo4be8816d70/10/mac/14.0
[Screen Reader Basics: VoiceOver]: https://www.youtube.com/watch?v=5R-6WvAihms
