module Jekyll
  module Zettel
    # Generate tags.json from page front matter
    class Tags < Jekyll::Generator
      include Jekyll::Zettel

      SLUG_FORMAT = %r{glosse/(?<slug>.*)/index.(?<ext>html|md)}i.freeze

      attr_reader :site

      def generate(site)
        @site = site

        @site.data['aliases'] = {}
        @site.data['tags'] = {}
        @site.data['tag2glosse'] = {}

        register

        write_catalog 'aliases'
        write_catalog 'tags'
        write_catalog 'tag2glosse'
      end

      def register
        @site.pages.each do |page|
          next unless SLUG_FORMAT.match?(page.path.to_s)

          register_tag(page)
          register_tags(page)
          register_aliases(page)
        end
      end

      def register_tag(doc)
        parts = doc.path.to_s.match(SLUG_FORMAT)
        @site.data['tags'][parts[:slug]] = {
          'slug' => parts[:slug],
          'tag' => doc.data['tag'] || 'Missing @tag',
          'title' => doc.data['title'] || 'Missing @title',
          'description' => doc.data['description'] || 'Missing @description',
          'tags' => doc.data['tags']
        }
        doc.data['slug'] = parts[:slug]
      end

      def register_aliases(doc)
        @site.data['aliases'][doc.data['tag']] = {
          'slug' => doc.data['slug'],
          'tag' => doc.data['tag'],
          'description' => doc.data['description']
        }
        return unless doc.data.key?('aliases')

        doc.data['aliases'].each do |item|
          @site.data['aliases'][item] = {
            'slug' => doc.data['slug'],
            'tag' => doc.data['tag'],
            'description' => doc.data['description']
          }
        end
      end

      def register_tags(doc)
        return unless doc.data.key?('tags')

        doc.data['tags'].each do |tag|
          @site.data['tag2glosse'][tag] = [] unless @site.data['tag2glosse'].key?(tag)

          @site.data['tag2glosse'][tag] << doc.data['slug']
        end
      end
    end
  end
end
