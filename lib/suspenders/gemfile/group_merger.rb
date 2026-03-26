# frozen_string_literal: true

module Suspenders
  module Gemfile
    class GroupMerger
      GROUP_PATTERN = /\Agroup\s+(?<group_name>.+?)\s+do\s*\n/
      END_PATTERN = /\Aend\s*\n?\z/

      Line = Struct.new(:content) do
        def render
          content
        end
      end

      Group = Struct.new(:group_name, :body) do
        def render
          "group #{group_name} do\n#{body.join}end\n"
        end
      end

      class Layout
        def initialize(entries)
          @leading_lines = []
          @displaced_lines = []
          @group_entries = []
          seen_group = false

          entries.each do |entry|
            case entry
            when Group
              seen_group = true
              @group_entries << entry
            when Line
              if seen_group
                @displaced_lines << entry unless entry.content.strip.empty?
              else
                @leading_lines << entry
              end
            end
          end

          @leading_lines.pop while @leading_lines.last&.content&.strip&.empty?
        end

        def render
          parts = []
          parts.concat(@leading_lines.map(&:render))
          parts.concat(@displaced_lines.map(&:render))
          parts << "\n" if parts.any?
          parts << @group_entries.map(&:render).join("\n")
          parts.join
        end
      end

      def self.merge(content)
        new(content).merge
      end

      def initialize(content)
        @lines = content.lines
        @groups = {}
        @parsed_lines = []
        @cursor = 0
      end

      def merge
        parse_gemfile
        cleanup Layout.new(parsed_lines).render
      end

      private

      attr_reader :lines, :groups, :parsed_lines
      attr_accessor :cursor

      def parse_gemfile
        while cursor < lines.length
          line = lines[cursor]
          self.cursor += 1

          if (match = line.match(GROUP_PATTERN))
            record_group(match[:group_name], extract_group_body)
          else
            parsed_lines << Line.new(line)
          end
        end
      end

      def extract_group_body
        body_lines = []

        while cursor < lines.length && !lines[cursor].match?(END_PATTERN)
          body_lines << lines[cursor]
          self.cursor += 1
        end

        self.cursor += 1
        body_lines
      end

      def record_group(group_name, body_lines)
        if groups.key?(group_name)
          groups[group_name].body.concat(body_lines)
        else
          group = Group.new(group_name, body_lines)
          groups[group_name] = group
          parsed_lines << group
        end
      end

      def cleanup(output)
        output.gsub(/\n{3,}/, "\n\n").rstrip + "\n"
      end
    end
  end
end
