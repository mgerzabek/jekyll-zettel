module Jekyll
  module Zettel
    # Enrich page front matter with object meta data
    class References < Jekyll::Generator
      include Jekyll::Zettel

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

        write_catalog 'references'
      end

      def configure_citeproc
        locale = @site.config['citation']['locale'] || 'en-US'
        style = @site.config['citation']['style'] || 'apa'

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
        if doc.data['reference'].include?('citation-key') && doc.data['reference'].include?('id')
          #
          # Citeproc erwartet sich eine id, die dem citation-key entspricht,
          # in den References (references.json) brauche ich jedoch die id des
          # Zettels, um in diversen Anwendungen darauf referenzieren zu können.
          # Also wird die id des Zettels zwischengespeichert und für die
          # Registrierung bei Citeproc durch den citation-key ersetzt.
          #
          # ACHTUNG!
          # Beim Übernehmen einer Reference aus Citavi muss die id manuell auf
          # die id des Zettels gesetzt werden!
          #
          # store
          id = doc.data['reference']['id']
          @site.data['references'][doc.data['reference']['citation-key']] = doc.data['reference']
          # set id for Citeproc and register Item
          doc.data['reference']['id'] = doc.data['reference']['citation-key']
          @site.config['citeproc'].register doc.data['reference']
          # restore
          doc.data['reference']['id'] = id
        else
          Jekyll.logger.warn LOG_KEY, 'missing property @citation-key'
          Jekyll.logger.warn '', file
        end
      end

    end
  end
end
