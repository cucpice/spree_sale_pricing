# encoding: UTF-8
version = '1.0.2'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_sale_pricing'
  s.version     = '0.3.10'
  s.summary     = 'Adds sale pricing functionality to Spree Commerce'
  s.description = 'Adds sale pricing functionality to Spree Commerce'
  s.required_ruby_version = '>= 1.9.2'

  s.author            = 'Jonathan Dean'
  s.email             = 'jon@jonathandean.com'
  s.homepage          = 'http://jonathandean.com'

  #s.files         = `git ls-files`.split("\n")
  s.files       = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*', 'vendor/**/*']
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'solidus_core', version
  s.add_dependency 'solidus_backend', version


  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails', '~> 5.0.0'

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  s.add_development_dependency 'sqlite3'
end
