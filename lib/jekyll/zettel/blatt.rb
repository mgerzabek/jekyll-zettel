module Jekyll
  module Zettel
    # Scaffolder for infotype Glosse
    class Blatt

      include Jekyll::Zettel

      def scaffold(args)
        return nil if args_empty?(args)

        slug = create_slug(args.first)
        file = "arbeitsblatt/#{slug}/index.md"
        return file if create_dir_defensively('Arbeitsblatt', slug, file).nil?

        create_page({ 'slug' => slug, 'title' => args.first }, file, 'blatt.md')

        Jekyll.logger.info '✓', "Created blatt with slug `#{slug}`"
        file
      end
    end
  end
end
