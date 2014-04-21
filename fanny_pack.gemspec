# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fanny_pack/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "fannypack"
  s.version     = FannyPack::VERSION
  s.authors     = ["Matt Diebolt", "Steel Fu"]
  s.email       = ["matt@polleverywhere.com", "steel@polleverywhere.com"]
  s.homepage    = ""
  s.summary     = %q{A simple set of base views to help develop Backbone applications.}
  s.description = %q{A simple set of base views to help develop Backbone applications.}

  # Manifest
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'middleman', '~> 3.3'
  s.add_development_dependency 'growl'
  s.add_development_dependency 'rb-fsevent'
end
