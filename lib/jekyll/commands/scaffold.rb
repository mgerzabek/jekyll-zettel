module Jekyll
  module Commands
    # Jekyll subcommand <scaffold>
    class Scaffold < Command
      class << self

        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        def init_with_program(prog)
          prog.command(:scaffold) do |c|
            c.syntax 'scaffold <option> [arg]'
            c.description 'Create new infotype scaffold'
            c.option 'akteur', '-a', '--akteur', 'scaffold a new Akteur; arg <full name> required'
            c.option 'blatt', '-b', '--blatt', 'scaffold a new Arbeitsblatt; arg <title> required'
            c.option 'glosse', '-g', '--glosse', 'scaffold a new Glosse; arg <title> required'
            c.option 'zeitleiste', '-e', '--zeitleiste', 'scaffold a new Zeitleiste; arg <title> required'
            c.option 'zettel', '-z', '--zettel', 'scaffold a new Zettel'
            c.action do |args, options|

              if options.empty?
                Jekyll.logger.error Jekyll::Zettel::LOG_KEY, 'Missing infotype, use: jekyll scaffold <option> [arg]'
              else
                infotype = options.keys[0].capitalize
                name = "Jekyll::Zettel::#{infotype}"
                if class_exists?(name)
                  clazz = name.split('::').inject(Object) do |o, c|
                    o.const_get c
                  end

                  file = clazz.new.scaffold(args)
                  system("code #{File.expand_path(file)}") unless file.nil?
                  # puts file
                else
                  Jekyll.logger.error Jekyll::Zettel::LOG_KEY, "Infotype `#{infotype}` not yet implemented"
                end
              end
            end
          end
        end

        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
        def class_exists?(clazz)
          klass = Module.const_get(clazz)
          klass.is_a?(Class)
        rescue NameError
          false
        end

      end
    end
  end
end
