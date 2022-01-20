module Jekyll
  module Zettel
    # Scaffolder for infotype Glosse
    class Glosse

      include Jekyll::Zettel

      def scaffold(args)
        return nil if args_empty?(args)

        slug = create_slug(args.first)
        file = "glosse/#{slug}/index.md"
        return file if create_dir_defensively('Glosse', slug, file).nil?

        create_page({ 'slug' => slug, 'title' => args.first }, file, 'glosse.md')

        Jekyll.logger.info '✓', "Created glosse with slug `#{slug}`"
        file
      end
    end
  end
end
