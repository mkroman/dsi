module DSI
  class Connection
    include DSI::Logging, DSI::Handling

    def initialize config, delegate
      @config   = config
      @delegate = delegate
    end
    
    def connect
      @socket = TCPSocket.new @config.hostname, @config.port
      transmit :PASS, @config.password if @config.password?
      transmit :NICK, @config.nickname
      transmit :USER, @config.username, ?*, ?*, @config.realname
      
      while line = @socket.gets
        command = Command.parse line
        debug "#{'<'^:green} #{command}"
        handle command
      end
    end
    
    def transmit command_name, *arguments
      command = Command.new command_name
      command.parameters = arguments
      debug "#{'>'^:red} #{command.to_s}"
      
      @socket.puts command.to_s
    end
    
    def send_event *args
      @delegate.send_event *args
    end

  end
end
