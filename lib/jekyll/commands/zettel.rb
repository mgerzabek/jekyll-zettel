module Jekyll
  module Commands
    # Jekyll subcommand <zettel>
    class Zettel < Command
      class << self

        def init_with_program(prog)
          prog.command(:zettel) do |c|
            c.syntax 'zettel'
            c.description 'Creates a new Zettel within subdir zettel'
            c.action do |_args, _options|
              uuid = new_zettel
              file = "zettel/#{uuid}/index.md"
              new_page(uuid, file)

              Jekyll.logger.info '✓', "Created new Zettel with UUID: `#{uuid}`"
              system("code #{File.expand_path(file)}")
            end
          end
        end

        def new_zettel
          uuid = SecureRandom.uuid
          dir = "zettel/#{uuid}"
          return new_zettel if File.directory?(dir)

          FileUtils.mkdir_p(dir)
          uuid
        end

        def new_page(uuid, file)
          File.open(file, 'w') { |out|
            out.write evaluate_template(uuid, 'index.md')
          }
        end

        # rubocop:disable Style/EvalWithLocation, Security/Eval, Lint/UnusedMethodArgument
        def evaluate_template(uuid, file)
          template = File.read(File.expand_path("../stubs/#{file}", __dir__))
          eval("\"#{template}\"")
        end
        # rubocop:enable Style/EvalWithLocation, Security/Eval, Lint/UnusedMethodArgument

      end
    end
  end
end
