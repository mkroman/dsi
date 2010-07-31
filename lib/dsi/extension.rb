module DSI
  class Extension < Module
    include DSI::Logging
    
    attr_accessor :filename
    
    def initialize filename
      @filename   = filename
      @bindings   = {}
      @properties = OpenStruct.new
      self.parse!
      @properties.author  ||= "unknown"
      @properties.version ||= "0.0.0"
      
      Extensions.add self if @extension.name
    end

    def run command, *args
      (@bindings[command.name] ||= []).each do |callback|
        method(callback).call *args
      end
    rescue Exception
      warn "Execution error: #{$!.message^:bold} on line #{$!.line^:bold}"
    end
    
    def config
      yield @config
    end
    
    def unload!
      @bindings.clear
    end
    
    def bind command, callback
      (@bindings[command.upcase] ||= []) << callback
    end
    
    def name; @extension.name end
    def author; @extension.author end
    def client; Extensions.delegate end
    def version; @extension.version end
    
  private
    def parse!
      module_eval File.read(path), filename, 0
      raise "extension #{path} needs a name!" unless @extension.name
    rescue Exception
      warn "Parse error: #{$!.message^:bold} on line #{$!.line^:bold}"
    end
    
    def path
      File.join Extensions.path, "#{@filename}.rb"
    end
    
    def method_added name
      module_function name
    end
    
  end
end	
