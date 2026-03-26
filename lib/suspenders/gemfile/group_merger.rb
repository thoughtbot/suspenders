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
        output = parsed_lines.map(&:render).join
        cleanup output
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
