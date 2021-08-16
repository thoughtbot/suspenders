require_relative "base"

module Suspenders
  class JsonGenerator < Generators::Base
    def add_oj
      gem "oj"
      bundle_install
    end
  end
end
