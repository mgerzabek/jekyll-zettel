module Jekyll
  module Zettel
    # Enrich page front matter with object meta data
    class References < Jekyll::Generator

      priority :highest

      attr_reader :site

      def generate(site)
        @site = site

        configure_citeproc

        site.pages.each do |page|
          next unless page.path.to_s.end_with?('index.html') || page.path.to_s.end_with?('index.md')

          tie_reference(page)
        end
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
          @site.config['citeproc'].register doc.data['reference']
          doc.data['citekey'] = doc.data['reference']['id']
        else
          Jekyll.logger.warn LOG_KEY, 'missing property @id'
          Jekyll.logger.warn '', "./#{file}"
        end
      end
    end
  end
end
