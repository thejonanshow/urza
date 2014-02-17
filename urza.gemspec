$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "urza/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = "urza"
  spec.version       = Urza::VERSION
  spec.authors       = ["Jonan Scheffler"]
  spec.email         = ["jonanscheffler@gmail.com"]
  spec.description   = %q{Urza identifies card images of Magic: The Gathering cards.}
  spec.summary       = %q{A library to scan Magic card images from a webcam and identify them using a database of known cards.}
  spec.homepage      = "http://github.com/1337807/urza"
  spec.license       = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.test_files = Dir["test/**/*"]

  spec.add_dependency "rails", "~> 4.0.0"
  spec.add_dependency "phashion"
  spec.add_dependency "rb_webcam"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry"
end
