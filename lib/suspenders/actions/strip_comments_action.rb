require "parser/current"

module Suspenders
  module Actions
    class StripCommentsAction
      class << self
        def call(source)
          parser = Parser::CurrentRuby.new

          source
            .then { |s| strip_comments(s, parser) }
            .then { |s| strip_trailing_whitespace(s) }
            .then { |s| strip_dup_newlines(s) }
            .then { |s| strip_leading_scope_newlines(s, parser) }
        end

        private

        def strip_comments(source, parser)
          StripComments.call(source, parser.reset)
        end

        def strip_trailing_whitespace(source)
          source.gsub(/[[:blank:]]+$/, "")
        end

        def strip_dup_newlines(source)
          source.gsub(/\n{2,}/, "\n\n")
        end

        def strip_leading_scope_newlines(source, parser)
          StripLeadingScopeNewlines.call(source, parser.reset)
        end
      end

      # Strips full-line and inline comments from a buffer but does
      # not remove whitespaces or newlines after the fact. Example
      # input:
      #
      #     MyGem.application.configure do |config|
      #       # Full-line comment
      #       config.option1 = :value # Inline comment
      #     end
      #
      # The output is:
      #
      #     MyGem.application.configure do |config|
      #
      #       config.option1 = :value
      #     end
      class StripComments
        class << self
          def call(source, parser)
            buffer = Parser::Source::Buffer.new(nil, source: source)
            rewriter = Parser::Source::TreeRewriter.new(buffer)

            _, comments = parser.parse_with_comments(buffer)

            comments.each do |comment|
              strip_comment(comment, buffer, rewriter)
            end

            rewriter.process
          end

          private

          def strip_comment(comment, buffer, rewriter)
            expr = comment.location.expression

            if full_line_comment?(expr)
              expr = full_line_comment_expr(expr, buffer)
            end

            rewriter.remove(expr)
          end

          def full_line_comment_expr(expr, buffer)
            pos = BackwardStringScanner.beginning_of_line_pos(expr, expr.begin_pos)

            Parser::Source::Range.new(buffer, pos, expr.end_pos + 1)
          end

          def full_line_comment?(expr)
            expr.source == expr.source_line.lstrip
          end
        end
      end

      # A tiny, non-stateful backward string scanner somewhat inspired
      # by Ruby's StringScanner. Ruby's StringScanner is unable to
      # seek backward on a string.
      class BackwardStringScanner
        def self.beginning_of_line_pos(expr, initial_pos)
          skip_before(expr, initial_pos) { |char| char == "\n" }
        end

        def self.skip_before(expr, initial_pos, &block)
          skip_until(expr, initial_pos, -1, &block)
        end

        def self.skip_until(expr, initial_pos, lookup_inc = 0)
          pos = initial_pos

          loop do
            break if pos.zero?
            char = expr.source_buffer.source[pos + lookup_inc]
            break if yield(char)
            pos -= 1
          end

          pos
        end
      end

      # The intent of this class is purely aesthetic: remove leading
      # newlines inside of code scopes like blocks and begin/end.
      # Example input:
      #
      #     module MyGem
      #
      #       MyGem.application.configure do |config|
      #
      #         config.option1 = true
      #
      #         config.option2 = false
      #       end
      #     end
      #
      # The output is:
      #
      #     module MyGem
      #       MyGem.application.configure do |config|
      #         config.option1 = true
      #
      #         config.option2 = false
      #       end
      #     end
      class StripLeadingScopeNewlines
        def self.call(source, parser)
          buffer = Parser::Source::Buffer.new(nil, source: source)
          ast = parser.parse(buffer)

          LeadingNewlineStripRewriter.new.rewrite(buffer, ast).lstrip
        end

        class LeadingNewlineStripRewriter < Parser::TreeRewriter
          def on_module(node)
            strip_newline_before(node.children[1])
            strip_newline_after(node.children.last)

            super
          end

          def on_class(node)
            strip_newline_before(node.children[2])
            strip_newline_after(node.children.last)

            super
          end

          def on_begin(node)
            handle_begin(node)

            super
          end

          def on_kwbegin(node)
            strip_newline_before(node.children[0])
            strip_newline_after(node.children.last)

            handle_begin(node)

            super
          end

          def on_block(node)
            strip_newline_before(node.children[2])
            strip_newline_after(node.children.last)

            super
          end

          private

          def handle_begin(node)
            strip_blank_lines_between_setter_calls(node.children)

            node.children.each do |child_node|
              send("on_#{child_node.type}", child_node)
            end
          end

          def strip_blank_lines_between_setter_calls(children)
            pairs = children.each_cons(2).to_a

            pairs.each do |(node_before, node_after)|
              if setter_call?(node_before) && setter_call?(node_after)
                strip_newline_before(node_after)
              end
            end
          end

          def setter_call?(node)
            node.children[1].to_s.end_with?("=")
          end

          def strip_newline_before(node)
            return if node.nil?

            expr = node.location.expression
            end_pos = find_end_pos(expr, expr.begin_pos)
            begin_pos = find_begin_pos(expr, end_pos)

            strip_source_range(expr, begin_pos, end_pos)
          end

          def strip_newline_after(node)
            return if node.nil?

            expr = node.location.expression
            source = expr.source_buffer.source

            if source[expr.end_pos + 1] == "\n"
              strip_source_range(expr, expr.end_pos, expr.end_pos + 1)
            end
          end

          def find_end_pos(expr, begin_pos)
            BackwardStringScanner.skip_until(expr, begin_pos) do |char|
              char == "\n"
            end
          end

          def find_begin_pos(expr, end_pos)
            BackwardStringScanner.skip_before(expr, end_pos) do |char|
              char != "\n" && char != " "
            end
          end

          def strip_source_range(expr, begin_pos, end_pos)
            remove(
              Parser::Source::Range.new(
                expr.source_buffer,
                begin_pos,
                end_pos
              )
            )
          end
        end
      end
    end
  end
end
