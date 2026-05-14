# frozen_string_literal: true

module Suspenders
  class GemfileConsolidator
    GROUP_BLOCK = /^group\s+(.+?)\s+do\n(.*?)\nend\n/m

    def self.call(content)
      new(content).call
    end

    def initialize(content)
      @content = content
    end

    def call
      tidy(top_level) + grouped.map { |key, bodies| render(key, bodies) }.join
    end

    private

    attr_reader :content

    def top_level
      content.gsub(GROUP_BLOCK, "")
    end

    def grouped
      content.scan(GROUP_BLOCK).each_with_object({}) do |(key, body), groups|
        (groups[key.strip] ||= []) << body
      end
    end

    def tidy(text)
      collapse_blank_lines(ensure_single_trailing_newline(text))
    end

    def collapse_blank_lines(text)
      text.gsub(/\n{3,}/, "\n\n")
    end

    def ensure_single_trailing_newline(text)
      text.sub(/\n+\z/, "\n")
    end

    def render(key, bodies)
      "\ngroup #{key} do\n#{bodies.join("\n\n")}\nend\n"
    end
  end
end
