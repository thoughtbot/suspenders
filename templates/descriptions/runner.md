Set up the app to run locally with ease.

Use Puma and the Rails jobs runner to run the app. This can be done via either
`heroku local` or any Foreman-compatible project runner (e.g. `foreman start`).

Configure your app using `.env`. Installs a basic `.sample.env` that is meant
to be checked into git and used as a template for your `.env`. The `bin/setup`
script is modified to safely copy `.sample.env` to `.env` for you.

Document all of this in the README.
