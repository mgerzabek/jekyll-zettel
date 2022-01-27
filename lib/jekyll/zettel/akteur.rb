module Jekyll
  module Zettel
    # Scaffolder for infotype Glosse
    class Akteur

      include Jekyll::Zettel

      def scaffold(args)
        return nil if args_empty?(args)

        slug = create_slug(args.first)
        file = "akteur/#{slug}/index.md"
        return file if create_dir_defensively('Akteur', slug, file).nil?

        create_page({ 'slug' => slug, 'title' => args.first }, file, 'akteur.md')

        Jekyll.logger.info '✓', "Created akteur with slug `#{slug}`"
        file
      end
    end
  end
end
