module Jekyll
  module Commands
    # Jekyll subcommand <zettel>
    class Zettel < Command
      class << self

        # rubocop:disable Metrics/MethodLength
        def init_with_program(prog)
          prog.command(:zettel) do |c|
            c.syntax 'zettel'
            c.description 'Creates a new Infotype'
            c.action do |args, _options|

              infotype = args[0] || 'zettel'

              if respond_to?("new_#{infotype}")

                file = public_send("new_#{infotype}", args)
                system("code #{File.expand_path(file)}") unless file.nil?

              else
                Jekyll.logger.error Jekyll::Zettel::LOG_KEY, "Invalid infotype #{infotype}"
              end

            end
          end
        end

        def new_glosse(args)
          if args[1].nil?
            Jekyll.logger.error Jekyll::Zettel::LOG_KEY, 'Missing argument slug'
            Jekyll.logger.info Jekyll::Zettel::LOG_KEY, 'usage: jekyll zettel glosse <slug>'
            nil
          else
            slug = create_slug(args[1])
            file = "glosse/#{slug}/index.md"
            return file if create_dir_defensively('Glosse', slug, file).nil?

            create_page({ 'slug' => slug, 'title' => args[1] }, file, 'glosse.md')

            Jekyll.logger.info '✓', "Created glosse with slug `#{slug}`"
            file
          end
        end

        def create_slug(title)
          I18n.config.available_locales = :de
          I18n.locale = :de
          I18n.backend.store_translations(:de, i18n: {
                                            transliterate: {
                                              rule: {
                                                'Ä' => 'Ae',
                                                'Ö' => 'Oe',
                                                'Ü' => 'Ue',
                                                'ü' => 'ue',
                                                'ö' => 'oe',
                                                'ä' => 'ae',
                                                'ß' => 'sz'
                                              }
                                            }
                                          })
          Jekyll::Utils.slugify(title, mode: 'latin')
        end

        def create_dir_defensively(infotype, slug, file)
          dir = File.dirname(file)
          if File.directory?(dir)
            if File.exist?(file)
              Jekyll.logger.error Jekyll::Zettel::LOG_KEY, "#{infotype} `#{slug}` already present"
              nil
            else
              dir
            end
          else
            FileUtils.mkdir_p(dir)
          end
        end

        def new_zettel(_args)
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

        def create_page(args, file, template)
          File.open(file, 'w') { |out| out.write evaluate_template(args, template) }
        end

        # rubocop:disable Style/EvalWithLocation, Security/Eval, Lint/UnusedMethodArgument
        def evaluate_template(args, template)
          string = File.read(File.expand_path("../stubs/#{template}", __dir__))
          eval("\"#{string}\"")
        end

      end
    end
  end
end
