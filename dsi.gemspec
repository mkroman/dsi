$:.unshift File.dirname(__FILE__) + "/lib"
require 'dsi'

Gem::Specification.new do |s|
  s.name     = "DSI"
  s.version  = DSI::VERSION
  s.summary  = "Damn Small IRC"

  s.author   = "Mikkel Kroman"
  s.email    = "mk@maero.dk"
  s.homepage = "http://github.com/mkroman/dsi"
  
  s.files    = Dir['lib/**/*.rb']
end
