module DSI
  class Extension < Module
    include DSI::Logging
    
    attr_accessor :filename, :extension
    
    def initialize delegate, filename
      @delegate  = delegate
      @filename  = filename
      @bindings  = {}
      @extension = OpenStruct.new
      parse!
      extension.author  ||= "unknown"
      extension.version ||= "0.0.0"
      
      delegate.add self if extension.name

      debug "#{'!'^:cyan} Loaded extension #{extension.name^:bold} (#{extension.version^:bold}) by #{extension.author^:bld}"
    end

    def run name, *args
      (@bindings[name] ||= []).each do |callback|
        method(callback).call *args
      end
    rescue Exception
      warn "Execution error: #{$!.message^:bold} on line #{$!.line^:bold}"
    end
    
    def config
      yield @extension
    end
    
    def unload!
      @bindings.clear
    end
    
    def bind command, callback
      (@bindings[command.upcase] ||= []) << callback
    end
    
    def name; @extension.name end
    def author; @extension.author end
    def client; @delegate.delegate end
    def version; @extension.version end

    alias_method :to_s, :name
    
  private
    def parse!
      module_eval File.read(path), filename, 0
      raise "extension #{path} needs a name!" unless @extension.name
    rescue Exception
      warn "Parse error: #{$!.message^:bold} on line #{$!.line^:bold}"
    end
    
    def path
      File.join @delegate.path, "#{@filename}.rb"
    end
    
    def method_added name
      module_function name
    end
    
  end
end	
