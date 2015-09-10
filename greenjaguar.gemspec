# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'greenjaguar/version'

Gem::Specification.new do |spec|
  spec.name          = "greenjaguar"
  spec.version       = Greenjaguar::VERSION
  spec.authors       = ["Aniruddha Deshpande"]
  spec.email         = ["anides84 AT hotmail DOT com"]
  spec.summary       = %q{Applies retry behavior to arbitrary code blocks with different policies like fibonacci,
exponential backoff, FixedInterval, etc. This basically is the 'retry' construct on steroids.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "minitest"
end
