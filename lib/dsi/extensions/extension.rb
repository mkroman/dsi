# encoding: utf-8
module DSI
  class Extension < Module

    attr_accessor :type, :triggers

    def initialize name
      extend ExtensionModuleMethods
      @name = name
      @type = :message
      parse! and exec :loaded
      Extensions.add self
      
    rescue Exception => exception
      Extensions.delegate.warn "Extension load error: #{exception.message^:bold} on line #{exception.line^:bold}"
    end

    def trigger? command
      if command.nil?
        true
      else
        if @triggers.nil?
          true
        else
          @triggers.include? command
        end
      end
    end

    def exec method, *args
      send method, *args if respond_to? method
    rescue Exception => exception
      Extensions.delegate.warn "Could not execute '#{method.to_s^:bold}': #{exception.message^:bold} on line #{exception.line^:bold}"
    end

    def unload!
      Extensions.delete self
      exec :unloaded
    end
    
    def path
      File.join Extensions.path, "#{@name}.rb"
    end
    
    def to_s
      @name.capitalize
    end
    
    def inspect
      %{<DSI::Extension @name="#{@name.capitalize}">}
    end

  private
    def parse!
      module_eval File.read(path), @name, 0
    end

    module ExtensionModuleMethods
      def method_added name
        module_function name
      end
    end

  end
end
