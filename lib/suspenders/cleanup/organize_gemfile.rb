module Suspenders
  module Cleanup
    class OrganizeGemfile
      def self.perform(gemfile)
        new(gemfile).perform
      end

      attr_reader :gemfile, :current_lines, :new_lines, :new_line_markers,
        :current_group, :gem_groups

      def initialize(gemfile)
        @gemfile = gemfile

        @current_lines = File.read(gemfile).lines
        @new_lines = []
        @new_line_markers = []

        @current_group = nil
        @gem_groups = {}
      end

      def perform
        remove_line_breaks
        sort_gems_and_groups
        add_gem_groups_to_gemfile
        add_line_breaks
        cleanup

        File.open(gemfile, "w+") { _1.write new_lines.join }
      end

      private

      def remove_line_breaks
        current_lines.delete("\n")
      end

      def sort_gems_and_groups
        current_lines.each do |line|
          if line.starts_with?(/group/)
            @current_group = line
          end

          # Consolidate gem groups
          if current_group
            if line.starts_with?(/end/)
              @current_group = nil
            elsif !line.starts_with?(/group/)
              gem_groups[current_group] ||= []
              gem_groups[current_group] << line
            end
          # Add non-grouped gems
          elsif !line.starts_with?(/\n/)
            new_lines << line
            @current_group = nil
          end
        end
      end

      def add_gem_groups_to_gemfile
        gem_groups.keys.each do |group|
          gems = gem_groups[group]

          gems.each_with_index do |gem, index|
            if index == 0
              new_lines << group
            end

            new_lines << gem

            if gems.size == (index + 1)
              new_lines << "end\n"
            end
          end
        end
      end

      def add_line_breaks
        new_lines.each_with_index do |line, index|
          previous_line = new_lines[index - 1] if index > 0
          next_line = new_lines[index + 1]
          marker = index + 1

          # Add line break if it's a gem and the next line is commented out
          if (line.starts_with?(/\s*gem/) || line.starts_with?(/\s*\#\s*gem/)) && next_line&.starts_with?(/\s*\#/)
            new_line_markers << marker
          end

          # Add line break if it's a commented out gem and the next line is a gem
          if line.starts_with?(/\s*\#\s*gem/) && next_line&.starts_with?(/\s*gem/)
            new_line_markers << marker
          end

          # Add line break if it's a gem with a comment and the next line is a gem
          if previous_line&.starts_with?(/\s*\#/) \
              && line.starts_with?(/\s*gem/) \
              && next_line&.starts_with?(/\s*gem/) \
              && !previous_line.starts_with?(/\s*\#\s*gem/)
            new_line_markers << marker
          end

          # Add a line break if it's /end/
          if line.starts_with?(/end/)
            new_line_markers << marker
          end

          # Add a line break if it's a gem and the next line is a group
          if line.starts_with?(/gem/) && next_line&.starts_with?(/group/)
            new_line_markers << marker
          end

          # Add line break if it's /source/ or /ruby/
          if line.starts_with?(/\w/) && !line.starts_with?(/\s*(gem|group|end)/)
            new_line_markers << marker
          end
        end

        new_line_markers.each_with_index do |marker, index|
          # Each time we insert, the original marker if off by 1
          marker_offset = marker + index

          new_lines.insert(marker_offset, "\n")
        end
      end

      def cleanup
        # Remove last line
        if /\n/.match?(new_lines.last)
          new_lines.pop
        end
      end
    end
  end
end
