module Kramdown
  module Parser
    # Kramdown Parser mit inline Zitationen
    class Citedown < Kramdown

      def initialize(source, options)
        super
        @citeproc = Jekyll.sites[0].config['citeproc']
        @references = Jekyll.sites[0].data['references']
        @zettel = Jekyll.sites[0].data['zettelkasten']
        @span_parsers.unshift(:citation)
      end

      CITATION = /\(@([\w,:]+)(;\s*(.*))?\)/.freeze

      def parse_citation
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size

        cite_key = @src[1]
        note = @src[3]
        citation = @citeproc.render :citation, id: cite_key, locator: note, label: :note
        attributes = {
          'href' => "/zettel/#{@references[cite_key]['id']}/",
          'title' => @zettel[@references[cite_key]['id']]['description'],
          'style' => 'box-shadow: initial; border: none;'
        }
        link = Element.new(:a, nil, attributes, location: start_line_number)

        link.children << Element.new(:raw, "<sup>#{citation}</sup>")
        @tree.children << link
      end

      define_parser(:citation, CITATION, '\(@')

    end
  end
end
# options => {
#   :template => "",
#   :auto_ids => true,
#   :auto_id_stripping => false,
#   :auto_id_prefix => "",
#   :transliterated_header_ids => false,
#   :parse_block_html => true,
#   :parse_span_html => true,
#   :html_to_native => false,
#   :link_defs => {},
#   :footnote_nr => 1,
#   :entity_output => :as_char,
#   :toc_levels => [1, 2, 3, 4, 5, 6],
#   :line_width => 72,
#   :latex_headers => ["section", "subsection", "subsubsection", "paragraph", "subparagraph", "subparagraph"],
#   :smart_quotes => ["lsquo", "rsquo", "ldquo", "rdquo"],
#   :typographic_symbols => {},
#   :remove_block_html_tags => true,
#   :remove_span_html_tags => false,
#   :header_offset => 0,
#   :syntax_highlighter => :rouge,
#   :syntax_highlighter_opts => {
#     :default_lang => "plaintext",
#     :guess_lang => true
#   },
#   :math_engine => :mathjax,
#   :math_engine_opts => {},
#   :footnote_backlink => "▲",
#   :footnote_backlink_inline => false,
#   :footnote_prefix => "",
#   :remove_line_breaks_for_cjk => false,
#   :forbidden_inline_options => [:template],
#   :input => "Citedown",
#   :hard_wrap => false,
#   :guess_lang => true,
#   :show_warnings => false,
#   :coderay => {}
# }
