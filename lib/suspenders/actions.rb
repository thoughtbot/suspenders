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

    def configure_environment(rails_env, config)
      inject_into_file(
        "config/environments/#{rails_env}.rb",
        "\n  #{config}",
        before: "\nend"
      )
    end

    def expand_json(file, data)
      action ExpandJson.new(destination_root, file, data)
    end

    class ExpandJson
      def initialize(destination_root, file, data)
        @destination_root = destination_root
        @file = file
        @data = data
      end

      def invoke!
        write_out { |existing_json| existing_json.merge(data) }
      end

      def revoke!
        write_out { |existing_json| hash_unmerge(existing_json, data) }
      end

      private

      attr_reader :destination_root, :file, :data

      def write_out
        new_json = yield(existing_json)
        IO.write(destination_file, JSON.pretty_generate(new_json))
      end

      def destination_file
        File.join(destination_root, file)
      end

      def existing_json
        JSON.parse(IO.read(destination_file))
      rescue Errno::ENOENT
        {}
      end

      def hash_unmerge(hash, subhash)
        subhash.reduce(hash) do |acc, (k, v)|
          if hash.has_key?(k)
            if v == hash[k]
              acc.except(k)
            elsif v.is_a?(Hash)
              acc.merge(k => hash_unmerge(hash[k], v))
            else
              acc
            end
          else
            acc
          end
        end
      end
    end
  end
end
