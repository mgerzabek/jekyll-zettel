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
  end
end

require 'jekyll/commands/zettel'
require 'jekyll/zettel/references'
require 'jekyll/zettel/reference'
