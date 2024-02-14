module Suspenders
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/setup", __FILE__)
      desc <<~TEXT
        A holistic setup script.

        ```sh
        bin/setup
        ```
      TEXT

      def replace_bin_setup
        copy_file "bin_setup.rb", "bin/setup", force: true
      end
    end
  end
end
