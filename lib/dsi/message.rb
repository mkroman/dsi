module DSI
  class Message
  
    attr_accessor :user, :channel, :body
  
    def initialize user, channel, body
      @user, @channel, @body = user, channel, body
    end
    
    def command; body.split(" ", 2)[0] end
    def  params; body.split(" ", 2)[1] end
    
    def extension # FIXME: this is somewhat unnecessary
      return user, channel, self
    end
    
  end
end
