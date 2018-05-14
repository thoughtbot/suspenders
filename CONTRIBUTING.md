# Contributing

We love pull requests from everyone. By participating in this project, you agree
to abide by the thoughtbot [code of conduct].

[code of conduct]: https://thoughtbot.com/open-source-code-of-conduct

Fork the repo:

    git clone git@github.com:thoughtbot/suspenders.git

Set up your machine:

    ./bin/setup

Make sure the tests pass:

    rake

Make your change.
Write tests.
Follow our [style guide][style].
Make the tests pass:

[style]: https://github.com/thoughtbot/guides/tree/master/style

    rake

Mention how your changes affect the project to other developers and users in the
`NEWS.md` file.

Write a [good commit message][commit].
Push to your fork.
[Submit a pull request][pr].

[commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[pr]: https://github.com/thoughtbot/suspenders/compare/

If [Hound] catches style violations,
fix them.

[hound]: https://houndci.com

Wait for us.
We try to at least comment on pull requests within one business day.
We may suggest changes.

## Versions

To update the Ruby version,
change `.ruby-version` and `.travis.yml`.

If you see this error while running tests:

```
Your Ruby version is XXX, but your Gemfile specified YYY (Bundler::RubyVersionMismatch)
```

Try removing the `tmp/` directory and re-running the tests.
