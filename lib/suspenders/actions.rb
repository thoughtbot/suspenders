require "net/http"

module Suspenders
  module Actions
    def config_url(github_repository, relative_path)
      github_uri_from_master_branch(github_repository, relative_path)
    end

    def download_file(uri, destination_path = "")
      file_contents = Net::HTTP.get(uri)
      filename = uri.path.split("/").last
      path = File.join(destination_root, destination_path, filename)

      File.open(path, "w") { |file| file.write(file_contents) }
    end

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
        "\n\n  #{config}",
        before: "\nend"
      )
    end

    private

    def github_uri_from_master_branch(repo_name, path)
      URI("https://raw.githubusercontent.com/#{repo_name}/master/#{path}")
    end
  end
end
