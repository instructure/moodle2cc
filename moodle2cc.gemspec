# -*- encoding: utf-8 -*-
require File.expand_path('../lib/moodle2cc/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christopher Durtschi", "Kevin Carter", "Instructure"]
  gem.email         = ["christopher.durtschi@gmail.com", "cartkev@gmail.com", "eng@instructure.com"]
  gem.description   = %q{Migrates Moodle backup ZIP to IMS Common Cartridge package}
  gem.summary       = %q{Migrates Moodle backup ZIP to IMS Common Cartridge package}
  gem.homepage      = "https://github.com/instructure/moodle2cc"

  gem.add_runtime_dependency "rubyzip"
  gem.add_runtime_dependency "happymapper"
  gem.add_runtime_dependency "builder"
  gem.add_runtime_dependency "thor"
  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "rdiscount"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-minitest"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "moodle2cc"
  gem.require_paths = ["lib"]
  gem.version       = Moodle2CC::VERSION
end
