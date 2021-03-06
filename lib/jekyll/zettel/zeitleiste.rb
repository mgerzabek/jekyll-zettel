module Jekyll
  module Zettel
    # Scaffolder for infotype Glosse
    class Zeitleiste

      include Jekyll::Zettel

      def scaffold(args)
        return nil if args_empty?(args)

        slug = create_slug(args.first)
        file = "zeitleiste/#{slug}/index.md"
        return file if create_dir_defensively('Zeitleiste', slug, file).nil?

        create_page({ 'slug' => slug, 'title' => args.first }, file, 'zeitleiste.md')
        string = File.read(File.expand_path('../stubs/timeline.json', __dir__))
        File.open("zeitleiste/#{slug}/timeline.json", 'w') { |out| out.write string }
        Jekyll.logger.info '✓', "Created zeitleiste with slug `#{slug}`"
        file
      end
    end
  end
end
