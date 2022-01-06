module Jekyll
  module Zettel
    # Generate tags.json from page front matter
    class Tags < Jekyll::Generator
      include Zettel

      SLUG_FORMAT = %r{glosse/(?<slug>.*)/index.(?<ext>html|md)}i.freeze

      attr_reader :site

      def generate(site)
        @site = site
        @site.data['tags'] = {}

        site.pages.each do |page|
          next unless SLUG_FORMAT.match?(page.path.to_s)

          register_tag(page)
        end

        write_catalog 'tags'
      end

      def register_tag(doc)
        parts = doc.path.to_s.match(SLUG_FORMAT)
        @site.data['tags'][parts[:slug]] = {
          'slug' => parts[:slug],
          'tag' => doc.data['tag'] || 'Missing @tag',
          'label' => doc.data['title'] || 'Missing @title',
          'description' => doc.data['description'] || 'Missing @description'
        }
      end

    end
  end
end
