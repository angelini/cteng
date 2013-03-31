# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cteng/version'

Gem::Specification.new do |spec|
  spec.name          = "cteng"
  spec.version       = Cteng::VERSION
  spec.authors       = ["Alex Angelini"]
  spec.email         = ["alex.louis.angelini@gmail.com"]
  spec.description   = "A draft implementation of my text-engine"
  spec.summary       = "Draft implementation of my text-engine"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "eventmachine"
  spec.add_dependency "ruby-termios"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
