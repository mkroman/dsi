module DSI
  class Message
    attr_accessor :user, :channel, :body
  
    def initialize user, channel, body
      @user, @channel, @body = user, channel, body
    end
    
    def private?
      @channel.prefix != '#'
    end
    
  end
end
