module Jekyll
  module Zettel
    # Enrich page front matter with object meta data
    class References < Jekyll::Generator

      priority :highest

      attr_reader :site

      def generate(site)
        @site = site

        @site.data['references'] = {}
        configure_citeproc

        site.pages.each do |page|
          next unless page.path.to_s.end_with?('index.html') || page.path.to_s.end_with?('index.md')

          tie_reference(page)
        end

        write_catalog
      end

      def configure_citeproc
        locale = @site.config['citeproc']['locale'] || 'en-US'
        style = @site.config['citeproc']['style'] || 'apa'

        @site.config['citeproc'] = CiteProc::Processor.new locale: locale, style: style, format: 'html'
        Jekyll.logger.info LOG_KEY, "Configured cite processor `#{locale}`/`#{style}`"
      end

      def tie_reference(doc)
        dir = File.dirname(doc.path)
        file = @site.in_source_dir(dir, 'reference.json')
        return unless File.exist?(file)

        doc.data['reference'] = SafeYAML.load_file(file)

        register_reference(doc, file)
      end

      def register_reference(doc, file)
        if doc.data['reference'].include?('id')
          @site.data['references'][doc.data['reference']['id']] = doc.data['reference']
          @site.config['citeproc'].register doc.data['reference']
          doc.data['citekey'] = doc.data['reference']['id']
        else
          Jekyll.logger.warn LOG_KEY, 'missing property @id'
          Jekyll.logger.warn '', "./#{file}"
        end
      end

      def write_catalog
        Jekyll.logger.info LOG_KEY, "Created references in `#{@site.in_dest_dir('.objects', 'references.json')}`"

        page = Jekyll::PageWithoutAFile.new(@site, @site.source, '.objects', 'references.json').tap do |file|
          file.content = JSON.pretty_generate(@site.data['references'])
          file.data.merge!(
            'layout' => nil,
            'sitemap' => false,
            )

          file.output
        end

        @site.pages << page
      end
    end
  end
end
