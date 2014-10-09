# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pillboxr', __FILE__)
require File.expand_path('../lib/pillboxr/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "pillboxr"
  s.version     = Pillboxr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Keith Gautreaux', 'David Hale', 'Darius Roberts', 'Mark Silverberg']
  s.email       = ['keith.gautreaux@gmail.com']
  s.homepage    = "http://rubygems.org/gems/pillboxr"
  s.summary     = "Access the NLM Pillbox API using Ruby."
  s.description = <<-END
Pillboxr is a Ruby wrapper for the National Library of Medicine Pillbox API Service located at http://pillbox.nlm.nih.gov.

The pillbox API provides information from the FDA about various prescription medications.

*Note:* This library is designed for use with Ruby 1.9.3 and above, and will not work with earlier versions of Ruby.
END

  s.rubyforge_project         = "pillboxr"

  s.add_dependency 'httparty', '~> 0.8.3'

  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency 'webmock', '~>1.8.8'
  s.add_development_dependency 'vcr', '~> 2.4.0'
  s.add_development_dependency 'yard', '~> 0.8.2.1'
  s.add_development_dependency 'redcarpet', '~> 2.1.1'

  s.files        = `git ls-files`.split("\n").delete_if { |fn| fn.match(/active(_|)resource/) }
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
