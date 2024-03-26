module Suspenders
  class OrganizeGemfile
    def self.perform(gemfile)
      new(gemfile).perform
    end

    attr_reader :gemfile, :lines, :current_group, :new_groups, :new_lines

    def initialize(gemfile)
      @gemfile = gemfile
      @lines = gemfile.read.lines
      @current_group = nil
      @new_groups = {}
      @new_lines = []
    end

    def perform
      lines.each_with_index do |line, index|
        if line.match /^group\s*/
          @current_group = line
        elsif current_group && (line.starts_with?(/\s*gem/) || line.starts_with?(/\s*\#/))
          new_groups[current_group] ||= []
          new_groups[current_group] << line
        elsif current_group && line.starts_with?(/\s*end/)
          new_groups[current_group] << line
          @current_group = nil
        elsif line.starts_with?(/\w/) || line.starts_with?(/\#/)
          @current_group = nil
          new_lines << line
        end
      end

      new_groups.each do |group|
        group.flatten.each do |line|
          new_lines << line
        end
      end

      pp new_lines

      gemfile.write(new_lines)
    end
  end
end
