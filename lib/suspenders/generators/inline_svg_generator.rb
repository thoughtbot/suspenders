require_relative "base"

module Suspenders
  class InlineSvgGenerator < Generators::Base
    def add_inline_svg
      gem "inline_svg"
      bundle_install
    end

    def configure_inline_svg
      copy_file "inline_svg.rb", "config/initializers/inline_svg.rb"
    end
  end
end
