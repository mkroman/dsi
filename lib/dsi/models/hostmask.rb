module DSI
  class Hostmask
    attr_accessor :nickname, :username, :hostname, :server, :type

    Pattern = /^(\S+)!(\S+)@(\S+)$/

    def initialize *hostmask
      if hostmask.length == 3
        @nickname, @username, @hostname = *hostmask
      else
        @server = hostmask.first
      end
    end
    
    def to_s
      if nickname
        "#{nickname}!#{username}@#{hostname}"
      else
        server
      end
    end
    
    def inspect
      if nickname
        %{<#{self.class.name} @nickname="#{@nickname}" @username="#{@username}" hostname="#{@hostname}">}
      else
        %{<#{self.class.name} @server="#{@server}">}
      end
    end

    def self.parse prefix
      if prefix =~ Pattern
        new $1, $2, $3
      else
        new prefix
      end
    end
    
  end
end
