require_relative "base"

module Suspenders
  class StylelintGenerator < Generators::Base
    def setup_hound
      action InvokeGenerator.new(self, "suspenders:lint")
      action ToggleComments.new(self, ".hound.yml", /stylelintrc/)
    end

    def install_stylelint
      dependencies = ["stylelint", "@thoughtbot/stylelint-config"]
      action YarnInstall.new(self, dependencies, "--dev")
    end

    def copy_stylelint_config
      copy_file "stylelintrc.json", ".stylelintrc.json"
    end

    class InvokeGenerator
      def initialize(base, generator)
        @base = base
        @generator = generator
      end

      def invoke!
        @base.invoke @generator
      end

      def revoke!; end
    end

    class ToggleComments
      def initialize(base, filename, pattern)
        @base = base
        @filename = filename
        @pattern = pattern
      end

      def invoke!
        @base.uncomment_lines(@filename, @pattern)
      end

      def revoke!
        @base.behavior = :invoke
        @base.comment_lines(@filename, @pattern)
      ensure
        @base.behavior = :revoke
      end
    end

    class YarnInstall
      def initialize(base, dependencies, flags)
        @base = base
        @dependencies = dependencies.join(" ")
        @flags = flags
      end

      def invoke!
        @base.run "bin/yarn add #{@dependencies} #{@flags}"
      end

      def revoke!
        @base.behavior = :invoke
        @base.run "bin/yarn remove #{@dependencies}"
      ensure
        @base.behavior = :revoke
      end
    end
  end
end
