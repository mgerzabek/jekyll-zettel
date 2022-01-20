module Jekyll
  module Zettel
    # Scaffolder for infotype Zettel
    class Zettel

      include Jekyll::Zettel

      def scaffold(_args)
        uuid = create_uuid
        file = "zettel/#{uuid}/index.md"
        create_page({ 'uuid' => uuid }, file, 'zettel.md')

        Jekyll.logger.info '✓', "Created new Zettel with UUID `#{uuid}`"
        file
      end

      def create_uuid
        uuid = SecureRandom.uuid
        dir = "zettel/#{uuid}"
        return create_uuid if File.directory?(dir)

        FileUtils.mkdir_p(dir)
        uuid
      end

    end
  end
end
