require_relative "base"

module Suspenders
  class PreloaderGenerator < Generators::Base
    def spring_config
      template "spring.rb", "config/spring.rb", force: false, skip: true
    end

    def spring_gem
      always_gsub_file("Gemfile", /# Spring speeds up development.*/, "")

      gem_group :development do
        gem "spring"
        gem "spring-watcher-listen", "~> 2.0.0"
      end

      Bundler.with_clean_env { run "bundle install" }
    end

    def cache_classes_test
      action UncacheClasses.new(self, "config/environments/test.rb")
    end

    def spring_binstubs
      action SpringBinstubs.new(self)
    end

    class SpringBinstubs
      def initialize(base)
        @base = base
      end

      def invoke!
        Bundler.with_clean_env do
          @base.send(:always_run, "spring binstub --all")
        end
      end

      def revoke!
        Bundler.with_clean_env do
          @base.send(:always_run, "spring binstub --remove --all")
        end
      end
    end

    class UncacheClasses
      def initialize(base, config_file)
        @base = base
        @config_file = config_file
      end

      def invoke!
        @base.send(
          :always_gsub_file,
          @config_file,
          "config.cache_classes = true",
          "config.cache_classes = false",
        )
      end

      def revoke!
        @base.send(
          :always_gsub_file,
          @config_file,
          "config.cache_classes = false",
          "config.cache_classes = true",
        )
      end
    end

    protected

    def always_run(command, with: nil, verbose: true, env: nil, capture: nil,
                   abort_on_failure: nil)
      destination = relative_to_original_destination_root(
        destination_root,
        false,
      )
      desc = "#{command} from #{destination.inspect}"

      if with
        desc = "#{File.basename(with.to_s)} #{desc}"
        command = "#{with} #{command}"
      end

      say_status :run, desc, verbose

      return if options[:pretend]

      env_splat = [env] if env

      if capture
        result, status = Open3.capture2e(*env_splat, command.to_s)
        success = status.success?
      else
        result = system(*env_splat, command.to_s)
        success = result
      end

      if abort_on_failure.nil?
        abort_on_failure = self.class.send(:exit_on_failure?)
      end

      if !success && abort_on_failure
        abort
      end

      result
    end

    def always_gsub_file(path, flag, replacement, verbose: true)
      path = File.expand_path(path, destination_root)
      say_status :gsub, relative_to_original_destination_root(path), verbose

      unless options[:pretend]
        content = File.binread(path)
        content.gsub!(flag, replacement)
        File.open(path, "wb") { |file| file.write(content) }
      end
    end
  end
end
