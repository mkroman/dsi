module DSI
  class Message
    attr_accessor :body
    Pattern = /^\x01([\w\s]+)\x01$/
  
    def initialize body, private = false
      @body    = body
      @private = private
    end

    def ctcp?
      body =~ Pattern
    end

    def ctcp
      body[/([\w\s]+)/]
    end
    
    def private?
      @private
    end

    def command
      @body.split[0]
    end

    def param index
      params = params()
      if params
        params.split[index]
      else
        nil
      end
    end

    def params
      @body.split(" ", 2)[1]
    end

    alias_method :to_s, :body
  end
end
