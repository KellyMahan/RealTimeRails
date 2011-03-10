Gem::Specification.new do |s|
    s.name = "RealTimeRails"
    s.version = '0.0.0' 
    s.platform = Gem::Platform::RUBY
    s.authors = ["Kelly Mahan"]
    s.email = 'kmahan@kmahan.com'
    s.summary = 'A gem to enable seamless websocket integration with rails.'
    s.homepage = 'http://github.com/kellymahan/'
    s.description = 'A gem to enable seamless websocket integration with rails.'


    s.rubyforge_project = 'RealTimeRails'


    s.files = `git ls-files`.split("\n")
    s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.require_path = 'lib'


    s.requirements << "em-websocket"
    s.requirements << "json"


    s.add_dependency "em-websocket", ">= 0.2.1"
    s.add_dependency "json", ">= 1.4.6"

end