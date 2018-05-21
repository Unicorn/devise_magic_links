# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_magic_links/version'

Gem::Specification.new do |spec|
  spec.name          = 'devise_magic_links'
  spec.version       = DeviseMagicLinks::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.license       = 'MIT'
  spec.authors       = ['Roberto DeGennaro']
  spec.email         = ['roberto@geteverwise.com']
  spec.summary       = 'Adds support for magic links to Devise.'
  spec.homepage      = 'https://github.com/everwise/devise_magic_links'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'devise', '>= 4.4.0'
  spec.add_development_dependency 'rspec', '~> 3.7.0'
end
