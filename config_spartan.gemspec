# -*- encoding: utf-8 -*-
require File.expand_path('../lib/config_spartan/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christopher J. Bottaro"]
  gem.email         = ["cjbottaro@alumni.cs.utexas.edu"]
  gem.description   = %q{Super simple application configuration gem}
  gem.summary       = %q{Ultra simple application configuration gem}
  gem.homepage      = "https://github.com/cjbottaro/config_spartan"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "config_spartan"
  gem.require_paths = ["lib"]
  gem.version       = ConfigSpartan::VERSION

  gem.add_runtime_dependency "hashie"
  gem.add_development_dependency "rspec"
end
