require_relative "base"

module Suspenders
  class LintGenerator < Generators::Base
    def set_up_hound
      copy_file "hound.yml", ".hound.yml"
    end
  end
end
