require 'dsi/logging'
require 'dsi/extension'

module DSI
  class Extensions
    
    @@delegate   = nil
    @@extensions = []
  
    def self.add extension
      @@extensions.push extension
    end
    
    def self.delete extension
      @@extensions.delete extension
    end
    
    def self.autoload
      Dir[path + "/*.rb"].each do |file|
        Extension.new File.basename(file, ".rb")
      end
    end
    
    def self.reload
      @@extensions.each &:unload!
      @@extensions.clear
      self.autoload
    end
    
    def self.all
      @@extensions
    end
    
    def self.run command, *args
      @@extensions.each { |extension| extension.run command, *args }
    end
    
    def self.[] name
      @@extensions.select{ |extension| extension.name == name }.first
    end
    
    def self.delegate= delegate
      @@delegate = delegate if @@delegate.nil?
    end
    
    def self.delegate
      @@delegate
    end
    
  private
    def self.path
      @@delegate.config.path || File.expand_path(File.join(File.dirname($0), "extensions"))
    end
  end
end

class DSI::Client
  @@extensions = true
end
