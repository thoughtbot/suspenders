# Releasing

1. Update `NEWS.md` to reflect the changes since last release.
2. Update `lib/suspenders/version.rb` file accordingly.
3. Commit changes. There shouldn't be code changes, and thus CI doesn't need to
   run; you can add `[ci skip]` to the commit message.
4. Tag the release: `git tag vVERSION -a -s`. The tag message should contain the
   appropriate `NEWS.md` subsection.
5. Push changes: `git push --tags`
6. Build and publish to rubygems:
   ```sh
   gem build suspenders.gemspec
   gem push suspenders-*.gem
   ```
7. Add a new GitHub release:
   https://github.com/thoughtbot/suspenders/releases/new?tag=vVERSION
8. Announce the new release, making sure to thank the contributors who helped
   shape this version!
