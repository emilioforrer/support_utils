$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "support_utils/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "support_utils"
  s.version     = SupportUtils::VERSION
  s.authors     = ["Emilio Forrer"]
  s.email       = ["emilio.forrer@gmail.com"]
  s.homepage    = "https://github.com/emilioforrer/support_utils"
  s.summary     = "Collection of utility classes, helpers and standard library extensions that were found useful for develop projects, faster."
  s.description = "SupportUtils is a collection of utility classes, helpers and standard library extensions that were found useful for develop projects, faster."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency             "rails", '>= 3', '>= 3.2'
  s.add_development_dependency "factory_girl", '>= 3'
  s.add_development_dependency "database_cleaner", '~> 1.4', '>= 1.4.1'
  s.add_development_dependency "faker", '~> 1.4', '>= 1.4.3'
  s.add_development_dependency "rspec", '~> 3.2', '>= 3.2.0'
  s.add_development_dependency "sqlite3", '~> 1.3', '>= 1.3.10'
end
