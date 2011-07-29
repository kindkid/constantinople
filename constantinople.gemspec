# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "constantinople/version"

Gem::Specification.new do |s|
  s.name        = "constantinople"
  s.version     = Constantinople::VERSION
  s.authors     = ["Chris Johnson"]
  s.email       = ["chris@kindkid.com"]
  s.homepage    = "https://github.com/kindkid/constantinople"
  s.summary     = "Load all your config/*.yml files"
  s.description = "Supports defaults, over-rides, and environments"

  s.rubyforge_project = "constantinople"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "map", "~> 4.2"
  s.add_dependency "deep_merge", "~> 1.0"
  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "simplecov", "~> 0.4"
  s.add_development_dependency("rb-fsevent", "~> 0.4") if RUBY_PLATFORM =~ /darwin/i
  s.add_development_dependency "guard", "~> 0.5"
  s.add_development_dependency "guard-bundler", "~> 0.1"
  s.add_development_dependency "guard-rspec", "~> 0.4"
end
