module Jekyll
  module Zettel
    # Enrich page front matter with timeline data
    class Timeline < Jekyll::Generator

      attr_reader :site

      def generate(site)
        @site = site

        site.pages.each do |page|
          next unless page.path.to_s.end_with?('index.html') || page.path.to_s.end_with?('index.md')

          tie_timeline(page)
        end
      end

      def tie_timeline(doc)
        dir = File.dirname(doc.path)
        file = @site.in_source_dir(dir, 'timeline.json')
        return unless File.exist?(file)

        doc.data['timeline'] = SafeYAML.load_file(file)
        doc.data['timeline']['src'] = "#{doc.url}timeline.json"
      end

    end
  end
end
