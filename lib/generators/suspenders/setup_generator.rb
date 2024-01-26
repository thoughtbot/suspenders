module Suspenders
  module Generators
    class SetupGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/setup", __FILE__)
      desc <<~TEXT
        A holistic setup script.

        ```sh
        bin/setup
        ```

        or

        ```sh
        WIPE_DATABASE=true bin/setup
        ```
      TEXT

      def create_brewfile
        copy_file "brewfile", "Brewfile"
      end

      def create_dev_prime
        copy_file "dev_prime.rb", "lib/tasks/dev.rake"
      end

      def replace_bin_setup
        copy_file "bin_setup.rb", "bin/setup", force: true
      end
    end
  end
end
