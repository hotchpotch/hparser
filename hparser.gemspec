# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "hparser"
  gem.description = "Hatena Syntax parser for Ruby"
  gem.homepage    = "https://github.com/hotchpotch/hparser"
  gem.summary     = gem.description
  gem.version     = File.read("VERSION").strip
  gem.authors     = ["HIROKI Mizuno", "Yuichi Tateno", "Nitoyon"]
  gem.email       = ""
  gem.has_rdoc    = false
  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_development_dependency "rake", ">= 0.9.2"
  gem.add_development_dependency "test-unit", "1.2.3" # for ruby 1.8
  gem.add_development_dependency "pry"
end

