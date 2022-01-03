require 'jekyll'
require 'securerandom'
require 'fileutils'

module Jekyll
  # Jekyll zettel to your service
  module Zettel

    autoload :VERSION, 'jekyll/laravel/bridge/version'

    LOG_KEY = 'Laravel Zettel'.freeze

    class Error < StandardError; end
  end
end

require 'jekyll/zettel/commands/zettel'
