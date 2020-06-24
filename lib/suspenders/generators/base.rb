require "rails/generators"
require_relative "../actions"

module Suspenders
  module Generators
    class Base < Rails::Generators::Base
      include Suspenders::Actions

      def self.default_source_root
        File.expand_path(File.join("..", "..", "..", "templates"), __dir__)
      end

      def self.inherited(subclass)
        super

        description_file = File.expand_path(
          File.join(
            default_source_root,
            "descriptions",
            "#{subclass.generator_name}.md"
          )
        )

        subclass.desc File.read(description_file)
      rescue Errno::ENOENT
      end

      private

      def app_name
        Rails.app_class.module_parent_name.demodulize.underscore.dasherize
      end

      def empty_directory_with_keep_file(destination)
        empty_directory(destination, {})
        keep_file(destination)
      end

      def keep_file(destination)
        create_file(File.join(destination, ".keep"))
      end

      def append_template_to_file(destination, source, *args)
        partial = File.expand_path(find_in_source_paths(source))
        append_to_file(destination, File.read(partial, *args))
      end

      def prepend_template_to_file(destination, source, *args)
        partial = File.expand_path(find_in_source_paths(source))
        prepend_to_file(destination, File.read(partial, *args))
      end

      def inject_template_into_file(destination, source, *args)
        partial = File.expand_path(find_in_source_paths(source))
        inject_into_file(destination, File.read(partial), *args)
      end
    end
  end
end
