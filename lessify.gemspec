# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lessify/version"

Gem::Specification.new do |s|
  s.name        = "lessify"
  s.version     = Lessify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Asif Sheikh"]
  s.email       = ["mail@asif.in"]
  s.homepage    = "https://github.com/tsycho/lessify"
  s.summary     = %q{Convert CSS files to SCSS files (LessCSS framework)}
  s.description = %q{Converts the flat structure of CSS files into heirarchical SCSS files. Also analyzes the various CSS tags to identify repeated patterns for potential extraction into mixins.}

  s.rubyforge_project = "lessify"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "css_parser"
  s.add_development_dependency "rspec"
end
