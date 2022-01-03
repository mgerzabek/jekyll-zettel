require_relative 'lib/jekyll/zettel/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-zettel'
  spec.version       = Jekyll::Zettel::VERSION
  spec.authors       = ['Michael Gerzabek']
  spec.email         = ['michael.gerzabek@gmail.com']

  spec.summary       = %q{Simple enhancements to use Jekyll as a simplistic Zettelkasten}
  spec.description   = %q{Coming soon…}
  spec.homepage      = 'https://michaelgerzabek.com/gems/jekyll-zettel'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mgerzabek/jekyll-zettel'
  spec.metadata['changelog_uri'] = 'https://github.com/mgerzabek/jekyll-zettel/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'fileutils', '>= 1.4', '< 2.0'
  spec.add_dependency 'jekyll', '>= 3.8', '< 5.0'
end
