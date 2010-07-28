module DSI
  class Extension < Module
    include DSI::Logging
    
    attr_accessor :filename
    
    def initialize filename
      @filename  = filename
      @bindings  = {}
      @extension = OpenStruct.new
      
      parse!
      @extension.name    ||= "unknown"
      @extension.version ||= "0.0.0"
      
      Extensions.add self 
    end

    def run command
      (@bindings[command.name] ||= []).each do |callback|
        method(callback).call *case command.name
        when :PRIVMSG then command.to_message.extension
        else command.params
        end
      end
    rescue Exception => exception
      warn "Extension execution error: #{exception.message^:bold} on line #{exception.line^:bold}"
    end
    
    def config
      yield @extension
    end
    
    def unload
      @bindings.clear
    end
    
    def bind command, callback
      (@bindings[command.upcase] ||= []) << callback
    end
    
    def method_added name
      module_function name
    end
    
  private
    def parse!
      module_eval File.read(path), filename, 0
      raise "extension #{path} needs a name!" unless @extension.name
      debug "#{'!'^:light_green} Loaded #{@extension.name.to_s^:bold} (#{@extension.version.to_s^:bold}) by #{@extension.author.to_s^:bold}"
    rescue Exception => exception
      warn "Extension parse error: #{exception.message^:bold} on line #{exception.line^:bold}"
    end
    
    def path
      File.join Extensions.path, "#{@filename}.rb"
    end
    
  end
end	
