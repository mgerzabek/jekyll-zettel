module Kramdown
  module Parser
    # Citation parser
    class Citedown

      CITATION = /\[@([\w,:]+)(;\s*(.*))?\]/.freeze

      def parse_citation
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size

        cite_key = @src[1]
        note = @src[3]

        if @references.key?(cite_key)
          add_citation(cite_key, note, start_line_number)
        else
          log_warning('cite-key', cite_key)
        end
      end

      def add_citation(cite_key, note, start_line_number)
        citation = @citeproc.render :citation, id: cite_key, locator: note, label: :note
        attributes = {
          'href' => "/zettel/#{@references[cite_key]['id']}/",
          'title' => @zettel[@references[cite_key]['id']]['title'],
          'class' => 'citation'
        }
        link = Element.new(:a, nil, attributes, location: start_line_number)

        link.children << Element.new(:raw, "<sup>#{citation}</sup>")
        @tree.children << link
      end

      define_parser(:citation, CITATION, '\[@')

    end
  end
end
