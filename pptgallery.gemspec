# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
 require 'pptgallery'

Gem::Specification.new do |spec|
  spec.name          = "pptgallery"
  spec.version       = PPTGallery::VERSION
  spec.authors       = ["kaakaa"]
  spec.email         = ["stooner.hoe@gmail.com"]
  spec.description   = %q{ppt/pptx slide gallery on CentOS}
  spec.summary       = %q{slide uploader and viewer}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra'
  spec.add_dependency 'builder'
  spec.add_dependency 'thin'
  spec.add_dependency 'foreman','0.61'
  spec.add_dependency 'haml'
  spec.add_dependency 'rack'
  spec.add_dependency 'rmagick'
  spec.add_dependency 'systemu'
  spec.add_dependency 'libreconv'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'sinatra-contrib'
  spec.add_development_dependency 'ruby-beautify'
end
