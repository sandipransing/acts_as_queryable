# -*- encoding: utf-8 -*-
require File.expand_path('../lib/aaq/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sandip Ransing"]
  gem.email         = ["sandip@joshsoftware.com"]
  gem.description   = %q{Adds querying ability with filters to our model}
  gem.summary       = %q{Adds querying ability with filters to our model"}
  gem.homepage      = "http://github.com/sandipransing/acts_as_queryable"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "aaq"
  gem.require_paths = ["lib"]
  gem.version       = Aaq::VERSION
end
