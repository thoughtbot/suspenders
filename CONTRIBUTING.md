# Contributing

We love contributions from everyone.
By participating in this project,
you agree to abide by the thoughtbot [code of conduct].

  [code of conduct]: https://thoughtbot.com/open-source-code-of-conduct

We expect everyone to follow the code of conduct
anywhere in thoughtbot's project codebases,
issue trackers, chatrooms, and mailing lists.

## Contributing Code

Fork the repo.

Run the setup script.

```
./bin/setup
```

Make sure the tests pass:

```
bin/rails test
```

Make sure there are no linting violations:

```
bin/rails standard
```

Make your change, with new passing tests.

Mention how your changes affect the project to other developers and users in the
`NEWS.md` file.

Push to your fork. Write a [good commit message][commit]. Submit a pull request.

  [commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

Others will give constructive feedback.
This is a time for discussion and improvements,
and making the necessary changes will be required before we can
merge the contribution.

## Testing Generators

There is a smaller dummy application at `test/dummy`. This application is used
as a mounting point for the engine, to make testing the engine extremely simple.

There are a number of [assertions][] and [helpers][] that make testing
generators easier.

[assertions]: https://api.rubyonrails.org/classes/Rails/Generators/Testing/Assertions.html
[helpers]: https://api.rubyonrails.org/classes/Rails/Generators/Testing/Behavior.html

## Publishing to RubyGems

When the gem is ready to be shared as a formal release, it can be
[published][published] to RubyGems.

  [published]: https://guides.rubyonrails.org/plugins.html#publishing-your-gem

1. Bump the version number in `Suspenders::VERSION`
2. Run `bundle exec rake build`
3. Run `bundle exec rake install`
4. Run `bundle exec rake release`
