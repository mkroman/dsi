module DSI
  class Message
  
    attr_accessor :user, :channel, :body
  
    def initialize user, channel, body
      @user, @channel, @body = user, channel, body
    end
    
    def command
      body.split(" ", 2)[0]
    end
    
    def params
      body.split[1..-1]
    end
    
    def extension # FIXME: this is unnecessary
      return user, channel, self
    end
    
  end
end
