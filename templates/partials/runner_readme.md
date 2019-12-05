## Configuration

Environment variables during local development are handled by the node-foreman
project runner. To provide environment variables, create a `.env` file at the
root of the project. In that file provide the environment variables listed in
`.sample.env`. The `bin/setup` script does this for you, but be careful about
overwriting your existing `.env` file.

`app.json` also contains a list of environment variables that are required for
the application. The `.sample.env` file provides either non-secret vars that
can be copied directly into your own `.env` file or instructions on where to
obtain secret values.

During development add any new environment variables needed by the application
to both `.sample.env` and `app.json`, providing either **public** default
values or brief instructions on where secret values may be found.

Do not commit the `.env` file to the git repo.

## Running the Application

Use the `heroku local` runner to run the app locally as it would run on Heroku.
This uses the node-forman runner, which reads from the `Procfile` file.

```sh
heroku local
```

Once the server is started the application is reachable at
`http://localhost:3000`.

