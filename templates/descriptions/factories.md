Build test data with clarity and ease.

This uses FactoryBot to help you define dummy and test data for your test
suite. The `create`, `build`, and `build_stubbed` class methods are directly
available to all tests.

We recommend putting FactoryBot definitions in one `spec/factories.rb` file, at
least until it grows unwieldy. This helps reduce confusion around circular
dependencies and makes it easy to jump between definitions.

Outside of the tests, the `dev:prime` rake task can be used to insert initial
development data into the database. You can use FactoryBot here, too.
