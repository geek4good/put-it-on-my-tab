# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "put_it_on_my_tab/version"

Gem::Specification.new do |spec|
  spec.name          = "put_it_on_my_tab"
  spec.version       = PutItOnMyTab::VERSION
  spec.authors       = ["Lucas Mbiwe"]
  spec.email         = ["lucas@geek4good.com"]
  spec.summary       = "A simplistic note-taking application"
  spec.description   = "A web service that allows clients to save and retrieve notes"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
