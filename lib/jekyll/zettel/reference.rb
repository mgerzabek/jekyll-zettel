module Jekyll
  module Zettel
    # Liquid tag that renders the reference the Zettel is based on
    class Reference < Liquid::Tag

      def render(context)
        return unless context.registers[:page].key?('citekey')

        context.registers[:site].config['citeproc'].render :bibliography, id: context.registers[:page]['citekey']
      end
    end
  end
end

Liquid::Template.register_tag('reference', Jekyll::Zettel::Reference)
