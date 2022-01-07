require 'jekyll'
require 'securerandom'
require 'fileutils'
require 'citeproc'
require 'csl/styles'

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
  end
end

require 'jekyll/commands/zettel'
require 'jekyll/zettel/references'
require 'jekyll/zettel/reference'
require 'jekyll/zettel/timeline'
require 'jekyll/zettel/tags'
require 'jekyll/zettel/zettelkasten'
