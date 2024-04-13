module Suspenders
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/setup", __FILE__)
      desc <<~MARKDOWN
        A holistic setup script.

        ```sh
        bin/setup
        ```
      MARKDOWN

      def replace_bin_setup
        copy_file "bin_setup.rb", "bin/setup", force: true
      end
    end
  end
end
