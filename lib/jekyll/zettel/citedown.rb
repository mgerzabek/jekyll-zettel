module Kramdown
  module Parser
    # Kramdown Parser mit inline Zitationen
    class Citedown < Kramdown

      def initialize(source, options)
        super
        site = Jekyll.sites[0]

        @citeproc = site.config['citeproc']
        @references = site.data['references']
        @keywords = site.data['aliases']
        @zettel = site.data['zettelkasten']

        @span_parsers.unshift(:citation, :keyword) # :emphase

        # So geht’s mit <i>, <b>, <em> und <strong> weiter
        #@span_parsers.delete(:emphasis)
      end

      def log_warning(catalog, entry)
        Jekyll.logger.warn 'Zettel:', "Missing entry for #{catalog} `#{entry}`"
        @tree.children << Element.new(:raw, "<span class=\"error\">Missing entry for #{catalog} `#{entry}`</span>")
      end

      require 'jekyll/zettel/parser/citation'
      require 'jekyll/zettel/parser/keyword'

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
