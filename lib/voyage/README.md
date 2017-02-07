## Updating to new Thoughtbot releases

### Files that we change in the mainline of the repo:

  * bin/voyage
  * suspenders.gemspec

Everything else is scoped to lib/voyage, so all of those changes will always apply cleanly after rebasing to upstream/master. Then just go back through each set of commits and make sure our overrides don't need some updating.

### Here are files we're currently overriding:

  * lib/suspenders/app_generator.rb => lib/voyage/app_generator.rb
  * templates/config_locales_en.yml.erb => lib/voyage/templates/config_locales_en.yml.erb
  * templates/Gemfile.erb               => lib/voyage/templates/Gemfile.erb
  * templates/rails_helper.rb.erb       => lib/voyage/templates/rails_helper.rb.erb
  * templates/README.md.erb             => lib/voyage/templates/README.md.erb

Everything else is a new file we want to add.

## Testing

Test that the new generator works, manually for now. It'd be awesome to get some [aruba](https://github.com/cucumber/aruba) tests going to test the various command line options / generated app permutations that are possible. For example, with and without devise, which templating language we should use, etc.

## Pushing a new release

  * Bump the version file: `lib/voyage/version.rb`

        VERSION = '1.44.0.6'.freeze

  * Tag the current commits on master BEFORE squashing (in case we want to refer to that diff history). Add a good commit message with what was done.

        git tag -a 1.44.0.6-voyage

  * Squash all new commits (assumed 3 here) into the 2 main commits (for a total of 5)

        git rebase -i HEAD~5

  * Force push the changes to master

        git push --force-with-lease --no-verify

  * Build the gem

        gem build suspenders.gemspec

  * Publish to rubygems

        gem push voyage-1.44.0.6.gem
