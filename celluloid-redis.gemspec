# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'celluloid/redis/version'

Gem::Specification.new do |spec|
  spec.name          = "celluloid-redis"
  spec.version       = Celluloid::Redis::VERSION
  spec.authors       = ["Tony Arcieri"]
  spec.email         = ["tony.arcieri@gmail.com"]
  spec.description   = "Celluloid::IO support for the redis-rb library"
  spec.summary       = "celluloid-redis provides a redis-rb connection class using Celluloid::IO"
  spec.homepage      = "https://github.com/celluloid/celluloid-redis"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redis"
  spec.add_runtime_dependency "celluloid-io", ">= 0.13.0.pre"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
end
