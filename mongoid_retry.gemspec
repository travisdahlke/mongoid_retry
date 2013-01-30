# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mongoid_retry/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Travis Dahlke"]
  gem.email         = ["travis.dahlke@tstmedia.com"]
  gem.description   = %q{Provides a 'save_and_retry' method that will attempt to save a document and, if a duplicate key error is thrown by mongodb, will update the existing document instead of failing.}
  gem.summary       = %q{Catch mongo duplicate key errors and retry}
  gem.homepage      = "http://www.github.com/travisdahlke/mongoid_retry"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mongoid_retry"
  gem.require_paths = ["lib"]
  gem.version       = MongoidRetry::VERSION

  gem.add_runtime_dependency "mongoid", ['> 2.0']
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "database_cleaner"
  gem.add_development_dependency('rake', ['>= 0.9.2'])
end
