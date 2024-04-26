module Suspenders
  module Generators
    class InlineSvgGenerator < Rails::Generators::Base
      include Suspenders::Generators::APIAppUnsupported
      source_root File.expand_path("../../templates/inline_svg", __FILE__)
      desc <<~MARKDOWN
        Uses [inline_svg][] for embedding SVG documents into views.

        Configuration can be found at `config/initializers/inline_svg.rb`

        [inline_svg]: https://github.com/jamesmartin/inline_svg
      MARKDOWN

      def add_inline_svg_gem
        gem "inline_svg"
        Bundler.with_unbundled_env { run "bundle install" }
      end

      def configure_inline_svg
        copy_file "inline_svg.rb", "config/initializers/inline_svg.rb"
      end
    end
  end
end
