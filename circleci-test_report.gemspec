lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "circleci/test_report/version"

Gem::Specification.new do |spec|
  spec.name    = "circleci-test_report"
  spec.version = CircleCI::TestReport::VERSION
  spec.authors = ["Akira Kusumoto"]
  spec.email   = ["akirakusumo10@gmail.com"]

  spec.summary     = "Create Test metadata for CircleCI"
  spec.description = "Create Test metadata for CircleCI"
  spec.homepage    = "https://github.com/bluerabbit/circleci-test_report"
  spec.license     = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "builder"
  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 2.2.33"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
