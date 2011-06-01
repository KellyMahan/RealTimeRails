Gem::Specification.new do |s|
    s.name = "real_time_rails"
    s.version = '0.0.2' 
    s.platform = Gem::Platform::RUBY
    s.authors = ["Kelly Mahan"]
    s.email = 'kmahan@kmahan.com'
    s.summary = 'A gem to enable seamless websocket integration with rails.'
    s.homepage = 'http://github.com/kellymahan/RealTimeRails'
    s.description = 'A gem to enable seamless websocket integration with rails.'


    s.rubyforge_project = 'real_time_rails'


    s.files = `git ls-files`.split("\n")
    s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.require_path = 'lib'


    s.requirements << "em-websocket"
    s.requirements << "json"
    

    s.add_dependency "em-websocket", ">= 0.3.0"
    s.add_dependency "rails", ">= 3.0.5"

end
