module Suspenders
  module Actions
    def replace_in_file(relative_path, find, replace)
      path = File.join(destination_root, relative_path)
      contents = IO.read(path)
      unless contents.gsub!(find, replace)
        raise "#{find.inspect} not found in #{relative_path}"
      end
      File.open(path, "w") { |file| file.write(contents) }
    end

    def action_mailer_host(rails_env, host)
      config = "config.action_mailer.default_url_options = { host: #{host} }"
      configure_environment(rails_env, config)
    end

    def action_mailer_asset_host(rails_env, host)
      config = "config.action_mailer.asset_host = #{host}"
      configure_environment(rails_env, config)
    end

    def configure_application_file(config)
      inject_into_file(
        "config/application.rb",
        "\n\n    #{config}",
        before: "\n  end"
      )
    end

    def configure_environment(rails_env, config)
      inject_into_file(
        "config/environments/#{rails_env}.rb",
        "\n  #{config}",
        before: "\nend"
      )
    end
  end
end
