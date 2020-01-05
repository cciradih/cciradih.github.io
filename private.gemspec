# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "private"
  spec.version       = "0.0.1"
  spec.authors       = ["Cciradih"]
  spec.email         = ["mountain@cciradih.top"]

  spec.summary       = "Private for Cciradih"
  spec.homepage      = "https://cciradih.top/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 2.1.3"
  spec.add_development_dependency "rake", "~> 12.0"
end
