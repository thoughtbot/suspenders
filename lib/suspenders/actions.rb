require "strscan"

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

    def gem(name, version = nil, **options)
      action Gem.new(destination_root, name, version, **options)
    end

    class ExpandJson
      def initialize(destination_root, file, data)
        @destination_root = destination_root
        @file = file
        @data = data
      end

      def invoke!
        write_out { |existing_json| existing_json.deep_merge(data) }
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
        JSON.parse(IO.read(destination_file), symbolize_names: true)
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

    class Gem
      def initialize(destination_root, name, version, **options)
        @destination_root = destination_root
        @name = name
        @version = version
        @groups = Array(options.delete(:group))
        @options = options
      end

      def invoke!
        existing_gemfile = IO.read(gemfile_path)

        if groups.present?
          positioning = gem_group(existing_gemfile)

          if positioning
            insert_gemline(existing_gemfile, indentation: 2, positioning: positioning)
          else
            positioning = final_group(existing_gemfile)

            if positioning
              insert_gemline(existing_gemfile, indentation: 2, positioning: positioning)
            else
              insert_gemline(existing_gemfile, indentation: 2, positioning: [0, existing_gemfile.bytes.size])
            end
          end
        else
          insert_gemline(existing_gemfile, indentation: 0, positioning: [0, existing_gemfile.bytes.size])
        end
      end

      def revoke!
        existing_gemfile = IO.read(gemfile_path)

        if groups.present?
          positioning = gem_group(existing_gemfile)

          if positioning
            remove_gemline(existing_gemfile, indentation: 2, positioning: positioning)
          end
        else
          remove_gemline(existing_gemfile, indentation: 0, positioning: [0, existing_gemfile.bytes.size])
        end
      end

      private

      attr_reader :destination_root, :name, :version, :groups, :options

      def gemfile_path
        File.join(destination_root, "Gemfile")
      end

      def gem_group(gemfile)
        groups_re = groups.map {|group| ":#{group}" }.join("[, ]+")
        data = /^group[ (]+#{groups_re}[ )]+do.+?^end/mo.match(gemfile)

        if data
          [data.begin(0), data[0].bytes.size]
        end
      end

      def final_group(gemfile)
        scanner = StringScanner.new(gemfile)
        result = nil

        while scanner.scan_until(/^group.+?do.+?^end+/m)
          if scanner.matched?
            result = [scanner.pos, scanner.matched.bytes.size]
          end
        end

        result
      end

      def insert_gemline(gemfile, indentation:, positioning:)
        position = subsequent_gemline(gemfile, indentation: indentation, positioning: positioning)

        if position
          insert_gemline_at(gemfile, positioning[0] + position, indentation: indentation)
        else
          final_positioning = final_line(gemfile, indentation: indentation, positioning: positioning)

          if final_positioning
            insert_gemline_at(gemfile, positioning[0] + final_positioning[1], indentation: indentation)
          else
            insert_gemline_at(gemfile, positioning[0] + positioning[1], indentation: indentation)
          end
        end
      end

      def remove_gemline(old_content, indentation:, positioning:)
        group_without_gem = old_content.byteslice(positioning[0], positioning[1]).
          sub(/^#{" " * indentation}gem[ (]+['"]#{name}.*\n/, "")
        new_content = old_content.byteslice(0, positioning[0]) +
          group_without_gem +
          old_content.byteslice((positioning[0] + positioning[1])..)

        announce
        IO.write(gemfile_path, new_content)
      end

      def subsequent_gemline(gemfile, indentation:, positioning:)
        scanner = StringScanner.new(
          gemfile.byteslice(positioning[0], positioning[1]),
        )

        while scanner.scan_until(/^#{" " * indentation}gem[ (]+['"]([^'"]+)/)
          if name < scanner.captures[0]
            return scanner.pos - scanner.matched.bytes.size
          end
        end

        nil
      end

      def insert_gemline_at(old_content, position, indentation:)
        announce
        IO.write(
          gemfile_path,
          new_content(old_content, position: position, indentation: indentation),
        )
      end

      def new_content(old_content, position:, indentation:)
        ensure_newline((old_content.byteslice(0, position) || "")) +
          (" " *indentation) +
          gemline +
          ensure_newline((old_content.byteslice(position..) || ""))
      end

      def final_line(gemfile, indentation:, positioning:)
        scanner = StringScanner.new(
          gemfile.byteslice(positioning[0], positioning[1]),
        )
        result = nil

        while scanner.scan_until(/#{" " *indentation}gem[ (]+['"][^'"]+['"]/)
          result = [scanner.pos, scanner.matched.bytes.size]
        end

        result
      end

      def ensure_newline(str)
        "#{str.chomp}\n"
      end

      def gemline
        parts = [name, version].compact.map { |part| part.inspect }

        options&.each_pair do |k,v|
          parts << %{#{k}: #{v.inspect}}
        end

        "gem #{parts.compact.join(", ")}\n"
      end

      def announce
        message = "#{name}"

        if version
          message << " (#{version})"
        end

        if options[:git]
          message = options[:git]
        end

        Thor::Base.shell.new.say_status :gemfile, message
      end

    end
  end
end
