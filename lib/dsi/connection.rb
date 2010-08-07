module DSI
  class Connection
    include DSI::Logging, DSI::Handling

    def initialize config, delegate
      @config, @delegate = config
      @delegate = delegate
    end
    
    def connect
      @socket = TCPSocket.new @config.hostname, @config.port
      debug "Connecting to #{@config.hostname^:light_green}:#{@config.port.to_s^:light_green}"
      transmit :PASS, @config.password if @config.password?
      transmit :NICK, @config.nickname
      transmit :USER, @config.username, ?*, ?*, @config.realname
      
      while line = @socket.gets
        handle Command.parse(line)
      end
    end
    
    def transmit command_name, *arguments
      command = Command.new command_name
      command.parameters = arguments
      debug "#{'>'^:red} #{command.to_s}"
      
      @socket.puts command.to_s
    end
    
    def send_event *arguments
      @delegate.send_event *arguments
    end
    
    def channels
      @delegate.channels
    end

  end
end
