# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'celluloid/redis/version'

Gem::Specification.new do |spec|
  spec.name          = "celluloid-redis"
  spec.version       = CELLULOID_REDIS_VERSION
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

  spec.add_runtime_dependency "redis",          "~> 3.2"
  spec.add_runtime_dependency "celluloid-io",   "~> 0.16"

  spec.add_development_dependency "rake",       "~> 10.4"
  spec.add_development_dependency "rspec",      "~> 3.0"
end
