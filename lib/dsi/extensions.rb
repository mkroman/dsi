# encoding: utf-8
module DSI
  class Extensions
    @@extensions = []
    @@delegate   = nil

    def self.run type, *args
      extensions = find type
      
      trigger = case type
        when :message then args[2].split.first
        else nil
      end
      
      extensions.each do |extension|
        extension.exec :init, *args if extension.trigger? trigger
      end
    end

    def self.add extension
      @@extensions << extension
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

    def self.delegate= delegate
      @@delegate = delegate
    end

    def self.delegate
      @@delegate
    end
    
    def self.find type
      list.select{ |extension| extension.type == type }
    end

    def self.list
      @@extensions
    end
    
    def self.path
      @@delegate.config.path || File.expand_path(File.join(File.dirname($0), "extensions"))
    end
  end
end

require 'dsi/extensions/extension'
require 'dsi/extensions/controller'
