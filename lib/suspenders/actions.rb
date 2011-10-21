module Suspenders
  module Actions
    def concat_file(source, destination)
      contents = IO.read(find_in_source_paths(source))
      append_file destination, contents
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
      inject_into_file(
        "config/environments/#{rails_env}.rb",
        "\n\n  config.action_mailer.default_url_options = { :host => '#{host}' }",
        :before => "\nend"
      )
    end

    def download_file(uri_string, destination)
      uri = URI.parse(uri_string)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri_string =~ /^https/
      request = Net::HTTP::Get.new(uri.path)
      contents = http.request(request).body
      path = File.join(destination_root, destination)
      File.open(path, "w") { |file| file.write(contents) }
    end
  end
end
