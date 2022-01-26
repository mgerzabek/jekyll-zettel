module Jekyll
  module Zettel
    # Generate tags.json from page front matter
    class Zettelkasten < Jekyll::Generator
      include Jekyll::Zettel

      priority :low

      SLUG_FORMAT = %r{zettel/(?<uuid>.*)/index.(?<ext>html|md)}i.freeze

      attr_reader :site

      def generate(site)
        @site = site
        @site.data['zettelkasten'] = {}
        @site.data['tag2zettel'] = {}

        site.pages.each do |page|
          next unless SLUG_FORMAT.match?(page.path.to_s)

          register_zettel(page)
          register_tags(page)
        end

        write_catalog 'zettelkasten'
        write_catalog 'tag2zettel'
      end

      def register_zettel(doc)
        @site.data['zettelkasten'][doc.data['id']] = {
          'zettel' => doc.data['id'],
          'title' => doc.data['title'],
          'description' => doc.data['description'],
          'author' => doc.data['author'],
          'tags' => doc.data['tags'],
          'folgezettel' => doc.data['folgezettel'],
          'via' => doc.data['via'],
          'citekey' => doc.data['citekey']
        }
      end

      def register_tags(doc)
        return unless doc.data.key?('tags')

        doc.data['tags'].each { |tag|
          @site.data['tag2zettel'][tag] = [] unless @site.data['tag2zettel'].key?(tag)

          @site.data['tag2zettel'][tag] << doc.data['zettel']
        }
      end
    end
  end
end
