# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rbcat/version"

Gem::Specification.new do |spec|
  spec.name          = "rbcat"
  spec.version       = Rbcat::VERSION

  spec.authors       = ["Victor Afanasev"]
  spec.email         = ["vicfreefly@gmail.com"]

  spec.summary       = "Colorize output by defined set of regex rules"
  spec.description   = "Colorize output by defined set of regex rules"
  spec.homepage      = "https://github.com/vifreefly/rbcat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = "rbcat"
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
