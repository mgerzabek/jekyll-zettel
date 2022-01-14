module Jekyll
  module Zettel
    # Enrich site variables with some meta data
    class Globals < Jekyll::Generator

      priority :highest

      def generate(site)
        site.data['url2page'] = {}

        site.pages.each do |page|
          site.data['url2page'][page.url] = page
        end
      end

    end
  end
end
