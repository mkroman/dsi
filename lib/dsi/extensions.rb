require 'dsi/logging'
require 'dsi/extension'

module DSI
  class Extensions
    attr_accessor :delegate
    
    def initialize delegate
      @delegate, @extensions = delegate, []
    end
  
    def add extension
      @extensions.push extension
    end
    
    def delete extension
      @extensions.delete extension
    end
    
    def load
      Dir[path + "/*.rb"].each do |file|
        Extension.new self, File.basename(file, ".rb")
      end
    end
    
    def reload
      @extensions.each &:unload!
      @extensions.clear
      load
    end
    
    def all
      @extensions
    end
    
    def run name, *args
      @extensions.each { |extension| extension.run name.upcase, *args }
    end
    
    def [] name
      @extensions.select{ |extension| extension.name == name }.first
    end
    
    def path
      @delegate.config.path || File.expand_path(File.join(File.dirname($0), "extensions"))
    end
  end
end
