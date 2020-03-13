# Goals

Suspenders is an opinionated platform for adding functionality to a Rails app.
It encodes thoughtbot's opinions and decisions in tooling and best practices.

We are transitioning to a library of generators. All new functionality must be
in the form of a well-tested, self-contained generator that fits within the
Suspenders framework.

## History and transitions

In the beginning suspenders was a git repo that we would clone then use as a
template for starting a new Rails app.

It then became a command-line tool that would generate a Rails app then modify
the files in place. Over time, and with intention, most of the modifications
were focused on modifying the Gemfile.

This was identified as unscalable and we have been slowing been moving in a new
direction: a library of generators.

## The future

The problem with a script that adds a bunch of gem requirements to the Gemfile
is: what if you don't want all those gems? Suspenders adds gem requirements and
then configures each one. On a typical project we would run Suspenders then
spend the rest of the day un-doing the parts we don't want.

In 2015, [PR #511], we discussed what we want: a gem that is a library of
generators that we can run on demand. The ideal future workflow goes like this:

[PR #511]: https://github.com/thoughtbot/suspenders/pull/511

1. `rails new my-cool-project && cd my-cool-project`
2. `echo "gem 'suspenders', group: :development" >> Gemfile && bundle`
3. `rails g suspenders:ci`
4. Repeat with other generators as needed.

In this future you would use `rails new` as normal and instead add Suspenders
as a development gem. This gives you access to opinionated generators for
adding (and removing!) whole functionality, but on demand and with your
knowledge.

The generators are all named to generically describe what functionality they
add. In this way we can change our opinions on the implementation without
needing to know new generator names. For example, `suspenders:ci` could
configure the app for CircleCI now, but down the road we may decide to switch
everything to Jenkins; we could update the implementation of the generator
without changing its name.

## From here to there

The transition looks like this:

1. Introduce a `suspenders:all` generator that runs Suspenders against an
   existing Rails app.
2. Change the Suspenders program to create a Rails app, add Suspenders to the
   Gemfile, and run `suspenders:all` inside of it.
3. Slowly split functionality out from the "all" generator and into smaller,
   well-tested, self-contained generators. The "all" generator invokes these
   generators.
4. Once that is completed -- once "all" _only_ calls other generators -- then
   remove the Suspenders program and only distribute the gem.

We are on step (3), and it's a big one. Come help out!
