module Kramdown
  module Parser
    # Keyword parser
    class Citedown

      KEYWORD = /\[#(\w+)\]/.freeze

      def parse_keyword
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size

        keyword = @src[1]
        if @keywords.key?(keyword)
          add_keyword(keyword, start_line_number)
        else
          log_warning('keyword', keyword)
        end
      end

      def add_keyword(keyword, start_line_number)
        attributes = {
          'href' => "/glosse/#{@keywords[keyword]['slug']}/",
          'title' => @keywords[keyword]['tag'],
          'class' => 'keyword'
        }
        link = Element.new(:a, nil, attributes, location: start_line_number)

        link.children << Element.new(:raw, keyword)
        @tree.children << link
      end

      define_parser(:keyword, KEYWORD, '\[#')

    end
  end
end
