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

    def set_up_erblint
      gem "better_html", group: [:development, :test]
      gem "erb_lint", require: false, group: [:development, :test]
      gem "erblint-github", require: false, group: [:development, :test]

      copy_file "erb-lint.yml", ".erb-lint.yml"
      copy_file "config_better_html.yml", "config/better_html.yml"
      copy_file "config_initializers_better_html.rb", "config/initializers/better_html.rb"
      copy_file "erblint.rake", "lib/tasks/erblint.rake"

      if using_rspec?
        copy_file "better_html_spec.rb", "spec/views/better_html_spec.rb"
      else
        copy_file "better_html_test.rb", "test/views/better_html_test.rb"
      end
    end

    private

    def using_rspec?
      File.exist?("spec/spec_helper.rb")
    end
  end
end
