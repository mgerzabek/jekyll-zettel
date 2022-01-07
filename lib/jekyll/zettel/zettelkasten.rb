module Jekyll
  module Zettel
    # Generate tags.json from page front matter
    class Zettelkasten < Jekyll::Generator
      include Zettel

      priority :low

      SLUG_FORMAT = %r{zettel/(?<uuid>.*)/index.(?<ext>html|md)}i.freeze

      attr_reader :site

      def generate(site)
        @site = site
        @site.data['zettelkasten'] = {}

        site.pages.each do |page|
          next unless SLUG_FORMAT.match?(page.path.to_s)

          register_zettel(page)
        end

        write_catalog 'zettelkasten'
      end

      def register_zettel(doc)
        @site.data['zettelkasten'][doc.data['zettel']] = {
          'zettel' => doc.data['zettel'],
          'title' => doc.data['title'],
          'description' => doc.data['description'],
          'author' => doc.data['author'],
          'tags' => doc.data['tags'],
          'folgezettel' => doc.data['folgezettel'],
          'via' => doc.data['via'],
          'citekey' => doc.data['citekey']
        }
      end

    end
  end
end
