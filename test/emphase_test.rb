require 'minitest/autorun'
require 'kramdown'
require 'yaml'

class EmphaseTest < Minitest::Test
  # Psych::DisallowedClass: Tried to load unspecified class: Symbol
  # https://github.com/puppetlabs/vmpooler/issues/240
  def test_parses_single_emphasis
    arg = File.join(File.dirname(__FILE__), 'emphase/*.text')
    Dir[arg].each do |file|

      html_file = file.sub('.text', '.html')
      opts_file = file.sub('.text', '.options')
      opts_file = File.join(File.dirname(file), 'options') unless File.exist?(opts_file)
      options = File.exist?(opts_file) ? YAML.safe_load(File.read(opts_file), permitted_classes: [Symbol]) : { auto_ids: false, footnote_nr: 1 }
      doc = Kramdown::Document.new(File.read(file), options)

      assert_equal(File.read(html_file), doc.to_html)
    end
  end
end
