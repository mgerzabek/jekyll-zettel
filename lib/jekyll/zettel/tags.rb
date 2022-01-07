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
        @site.data['tag2glosse'] = {}

        site.pages.each do |page|
          next unless SLUG_FORMAT.match?(page.path.to_s)

          register_tag(page)
        end

        write_catalog 'tags'
        write_catalog 'tag2glosse'
      end

      def register_tag(doc)
        parts = doc.path.to_s.match(SLUG_FORMAT)
        @site.data['tags'][parts[:slug]] = {
          'slug' => parts[:slug],
          'tag' => doc.data['tag'] || 'Missing @tag',
          'label' => doc.data['title'] || 'Missing @title',
          'description' => doc.data['description'] || 'Missing @description',
          'tags' => doc.data['tags']
        }
        doc.data['slug'] = parts[:slug]
        register_tags(doc)
      end

      def register_tags(doc)
        return unless doc.data.key?('tags')

        doc.data['tags'].each { |tag|
          @site.data['tag2glosse'][tag] = [] unless @site.data['tag2glosse'].key?(tag)

          @site.data['tag2glosse'][tag] << doc.data['slug']
        }
      end
    end
  end
end
