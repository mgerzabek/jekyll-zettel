module Jekyll
  module Zettel
    # Liquid tag that renders the reference the Zettel is based on
    class Reference < Liquid::Tag

      def render(context)
        doc = context.registers[:page]
        return unless doc.key?('reference') && doc['reference'].key?('citation-key')

        context.registers[:site].config['citeproc'].render :bibliography, id: doc['reference']['citation-key']
      end
    end
  end
end

Liquid::Template.register_tag('reference', Jekyll::Zettel::Reference)
