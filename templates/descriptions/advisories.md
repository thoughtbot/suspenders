Show security advisories during development.

Uses the `bundler-audit` gem and rake task to update the local security
database and show any relevant issues with the app's dependencies. This happens
on every test run and interaction with `bin/rake` and `bin/rails`.
