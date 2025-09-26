# frozen_string_literal: true

require_relative 'lib/nebius/version'

Gem::Specification.new do |spec|
  spec.name = 'nebius-cli-ruby'
  spec.version = Nebius::VERSION
  spec.authors = ['Manus AI']
  spec.email = ['support@manus.im']

  spec.summary = 'Ruby wrapper for the Nebius CLI'
  spec.description = 'A Ruby gem that provides a convenient interface to interact with Nebius cloud services through the Nebius CLI'
  spec.homepage = 'https://github.com/nebius/nebius-cli-ruby'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/nebius/nebius-cli-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/nebius/nebius-cli-ruby/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'json', '~> 2.0'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'cucumber', '~> 9.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency 'yard', '~> 0.9'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
