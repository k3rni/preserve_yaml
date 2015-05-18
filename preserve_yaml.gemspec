# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'preserve_yaml/version'

Gem::Specification.new do |spec|
  spec.name          = "preserve_yaml"
  spec.version       = PreserveYaml::VERSION
  spec.authors       = ["Krzysztof Zych"]
  spec.email         = ["krzysztof.zych@efigence.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{Preserve some YAML metadata.}
  spec.description   = %q{Tries to preserve YAML anchors and merges.}
  spec.homepage      = "https://github.com/k3rni/preserve_yaml"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
