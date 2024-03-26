module Suspenders
  module Generators
    module Install
      class WebGenerator < Rails::Generators::Base
        include Suspenders::Generators::APIAppUnsupported
        include Suspenders::Generators::DatabaseUnsupported

        def invoke_generators
          # This needs to go first, since it configures `.node-version`
          generate "suspenders:prerequisites"

          generate "suspenders:accessibility"
          generate "suspenders:advisories"
          generate "suspenders:email"
          generate "suspenders:factories"
          generate "suspenders:inline_svg"
          generate "suspenders:lint"
          generate "suspenders:rake"
          generate "suspenders:setup"
          generate "suspenders:tasks"
          generate "suspenders:testing"
          generate "suspenders:views"

          # jobs needs to be invoked before styles, since the syles generator
          # creates Procfile.dev
          generate "suspenders:styles"
          generate "suspenders:jobs"

          # Needs to be run last since it depends on lint, testing, and
          # advisories
          generate "suspenders:ci"
        end

        def lint
          run "yarn run fix:prettier"
          run "bundle exec rake standard:fix_unsafely"
        end
      end
    end
  end
end
