require File.join(File.dirname(__FILE__), 'lib', 'legal_beagle', 'info')

Gem::Specification.new do |s|
  s.name        = LegalBeagle.name
  s.version     = LegalBeagle.version
  s.summary     = LegalBeagle.summary
  s.description = LegalBeagle.description

  s.add_dependency 'jekyll', '~> 0.7.0'
  s.add_dependency 'prawn',  '~> 0.11.1'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'

  s.files       = Dir['README.md', 'lib/**/*.rb'].to_a
  s.has_rdoc    = false
  s.author      = 'Mat Schaffer'
  s.email       = 'mat@mashion.net'
  s.homepage    = 'http://github.com/mashion/legal_beagle'

  s.rubyforge_project = "nowarning"
end
