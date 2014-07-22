# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "crafty_clicks"
  spec.version       = '0.0.8'
  spec.authors       = ["Michael Malet"]
  spec.email         = ["michael@nervd.com"]
  spec.summary       = %q{Crafty Clicks - Addresses by Postcode}
  spec.description   = %q{This gem interfaces with Crafty Clicks' JSONP API}
  spec.homepage      = "https://github.com/malet/crafty_clicks"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 0'
end
