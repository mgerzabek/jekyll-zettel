module Kramdown
  module Parser
    # Emphasis parser (<i>/<em>)
    class Citedown

      EMPHASE_START = /__?/.freeze

      def parse_emphase
        start_line_number = @src.current_line_number
        saved_pos = @src.save_pos

        result = @src.scan(EMPHASE_START)
        element = (result.length == 2 ? :strong : :em)
        type = result[0..0]

        if (type == '_' && @src.pre_match =~ /[[:alpha:]]-?[[:alpha:]]*\z/) || @src.check(/\s/) ||
           @tree.type == element || @stack.any? { |el, _| el.type == element }
          add_text(result)
          return
        end

        sub_parse = lambda do |delim, elem|
          el = if elem == :strong
                 Element.new(:em, nil, nil, location: start_line_number)
               else
                 Element.new(:raw, '<i>', nil, start_line_number)
               end
          stop_re = /#{Regexp.escape(delim)}/
          found = parse_spans(el, stop_re) do
            (@src.pre_match[-1, 1] !~ /\s/) &&
              (elem != :em || !@src.match?(/#{Regexp.escape(delim * 2)}(?!#{Regexp.escape(delim)})/)) &&
              (type != '_' || !@src.match?(/#{Regexp.escape(delim)}[[:alnum:]]/)) && !el.children.empty?
          end
          [found, el, stop_re]
        end

        found, el, stop_re = sub_parse.call(result, element)
        if !found && element == :strong && @tree.type != :em
          @src.revert_pos(saved_pos)
          @src.pos += 1
          found, el, stop_re = sub_parse.call(type, :em)
        end
        if found
          @src.scan(stop_re)
          @tree.children << el
        else
          @src.revert_pos(saved_pos)
          @src.pos += result.length
          add_text(result)
        end
      end

      define_parser(:emphase, EMPHASE_START, '_')

    end
  end
end
