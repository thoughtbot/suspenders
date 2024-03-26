module Suspenders
  module Generators
    class InlineSvgGenerator < Rails::Generators::Base
      include Suspenders::Generators::APIAppUnsupported
      source_root File.expand_path("../../templates/inline_svg", __FILE__)
      desc "Render SVG images inline, as a potential performance improvement for the viewer."

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
