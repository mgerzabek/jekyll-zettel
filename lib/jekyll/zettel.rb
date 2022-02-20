require 'jekyll'
require 'securerandom'
require 'fileutils'
require 'citeproc'
require 'csl/styles'
require 'kramdown/parser/kramdown'

module Jekyll
  # Jekyll zettel to your service
  module Zettel

    autoload :VERSION, 'jekyll/zettel/version'

    LOG_KEY = 'Zettel:'.freeze

    class Error < StandardError; end

    def write_catalog(object)
      Jekyll.logger.info LOG_KEY, "Created references in `#{@site.in_dest_dir('.objects', "#{object}.json")}`"

      page = Jekyll::PageWithoutAFile.new(@site, @site.source, '.objects', "#{object}.json").tap do |file|
        file.content = JSON.pretty_generate(@site.data[object.to_s])
        file.data.merge!(
          'layout' => nil,
          'sitemap' => false,
        )

        file.output
      end

      @site.pages << page
    end

    def create_page(args, file, template)
      File.open(file, 'w') { |out| out.write evaluate_template(args, template) }
      # puts evaluate_template(args, template)
    end

    # rubocop:disable Style/EvalWithLocation, Security/Eval, Lint/UnusedMethodArgument
    def evaluate_template(args, template)
      string = File.read(File.expand_path("../stubs/#{template}", __FILE__))
      eval("\"#{string}\"")
    end

    # rubocop:enable Style/EvalWithLocation, Security/Eval, Lint/UnusedMethodArgument
    # rubocop: disable Layout/FirstHashElementIndentation, Metrics/MethodLength
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
          Jekyll.logger.error LOG_KEY, "#{infotype} `#{slug}` already present"
          nil
        else
          dir
        end
      else
        FileUtils.mkdir_p(dir)
      end
    end

    def args_empty?(args)
      return false unless args.empty?

      Jekyll.logger.error LOG_KEY, 'Missing argument slug'
      Jekyll.logger.info LOG_KEY, 'usage: jekyll scaffold --glosse <slug>'
      true
    end
  end
end

require 'jekyll/commands/scaffold'
require 'jekyll/zettel/akteur'
require 'jekyll/zettel/blatt'
require 'jekyll/zettel/citedown'
require 'jekyll/zettel/globals'
require 'jekyll/zettel/glosse'
require 'jekyll/zettel/reference'
require 'jekyll/zettel/references'
require 'jekyll/zettel/tags'
require 'jekyll/zettel/timeline'
require 'jekyll/zettel/zeitleiste'
require 'jekyll/zettel/zettel'
require 'jekyll/zettel/zettelkasten'

