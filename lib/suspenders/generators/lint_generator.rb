require_relative "base"

module Suspenders
  class LintGenerator < Generators::Base
    def set_up_hound
      copy_file "hound.yml", ".hound.yml"
    end

    def set_up_standard
      gem "standard", group: :development
      prepend_to_file("Rakefile", 'require "standard/rake"')
    end
  end
end
