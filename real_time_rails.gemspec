
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'real_time_rails/version'

Gem::Specification.new do |s|
    s.name = "real_time_rails"
    s.version = RealTimeRails::VERSION
    s.platform = Gem::Platform::RUBY
    s.authors = ["Kelly Mahan"]
    s.email = 'kmahan@kmahan.com'
    s.summary = 'A gem to enable seamless actioncable integration with rails.'
    s.homepage = 'http://github.com/kellymahan/RealTimeRails'
    s.description = 'A gem to enable seamless actioncable integration with rails.'


    s.rubyforge_project = 'real_time_rails'


    s.files = `git ls-files`.split("\n")
    s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.require_path = 'lib'


    s.add_dependency('actioncable')
    s.add_dependency('puma')

end
