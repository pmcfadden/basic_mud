# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'classless_mud/version'

Gem::Specification.new do |spec|
  spec.name          = 'classless_mud'
  spec.version       = ClasslessMud::VERSION
  spec.authors       = ['Patrick McFadden']
  spec.email         = ['pemcfadden@gmail.com']
  spec.summary       = 'Simple Mud Server'
  spec.description   = 'Run your own server'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'dm-sqlite-adapter'
  spec.add_dependency 'dm-postgres-adapter'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'eventmachine'
  spec.add_dependency 'datamapper'
  spec.add_dependency 'rufus-lua'
end
