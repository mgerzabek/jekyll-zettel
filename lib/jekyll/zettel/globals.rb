module Jekyll
  module Zettel
    # Enrich site variables with some meta data
    class Globals < Jekyll::Generator

      priority :lowest

      def generate(site)
        site.data['url_page'] = {}

        site.pages.each do |page|
          site.data['url_page'][page.url] = page
        end
      end

    end
  end
end
