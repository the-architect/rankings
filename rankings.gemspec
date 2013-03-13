# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rankings/version'

Gem::Specification.new do |spec|
  spec.name          = 'rankings'
  spec.version       = Rankings::VERSION
  spec.authors       = %w(the-architect)
  spec.email         = %w(marcel.scherf@epicteams.com)
  spec.description   = %q{gem description}
  spec.summary       = %q{gem summary}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  # storage
  spec.add_dependency 'redis'
  spec.add_dependency 'redis-namespace'

  # api
  spec.add_dependency 'grape'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'


  # test related gems
  spec.add_development_dependency 'fakeredis'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'mocha', '>= 0.13.2'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-html'
  spec.add_development_dependency 'watchr'

end
