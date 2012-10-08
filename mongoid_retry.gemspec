# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mongoid_retry/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Travis Dahlke"]
  gem.email         = ["travis.dahlke@tstmedia.com"]
  gem.description   = %q{Catch mongo duplicate key errors and retry}
  gem.summary       = %q{Catch mongo duplicate key errors and retry}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mongoid_retry"
  gem.require_paths = ["lib"]
  gem.version       = MongoidRetry::VERSION

  gem.add_development_dependency "rspec"
  gem.add_dependency "mongoid"
end
