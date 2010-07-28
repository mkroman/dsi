module DSI
  class Client
    include DSI::Logging

    attr_accessor :config, :connection
  
    def initialize options
      @config = Configuration.new options
      @events = {}
    end
    
    # Launches a connection, which pushes a call to #connected onto the runloop.
    def connect
      @connection = Connection.new @config, self
      @connection.connect
    end
    
    def register_event name, &p
      (@events[name] ||= []) << p
    end
    
    def send_event name, *arguments
      @events[name].each{ |b| b.call(*arguments) } if @events.key? name
    end
    
    # irc api
    def say recipient, message
      @connection.transmit :PRIVMSG, recipient, message
    end
    
    alias_method :on, :register_event
    alias_method :hook, :instance_eval
  end
end
