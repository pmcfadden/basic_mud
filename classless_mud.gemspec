# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'classless_mud/version'

Gem::Specification.new do |spec|
  spec.name          = "classless_mud"
  spec.version       = ClasslessMud::VERSION
  spec.authors       = ["Patrick McFadden"]
  spec.email         = ["pemcfadden@gmail.com"]
  spec.summary       = %q{Simple Mud Server}
  spec.description   = %q{Run your own server}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
