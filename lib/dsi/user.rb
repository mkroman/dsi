module DSI
  class User
    
    attr_accessor :prefix, :channel
    
    def initialize id, channel = nil
      self.prefix = case id
      when     String then "#{id}!nil@nil".to_mask
      when OpenStruct then id
      end
      self.channel = channel
    end
    
    def say message
      channel.delegate.say nickname, message
    end
    
    def nickname; prefix.nickname end
    def username; prefix.username end
    def realname; prefix.realname end
    def admin?; @channel.delegate.config.admin? prefix end
    
    def     op!; @channel.op self end
    def  voice!; @channel.voice self end
    def  admin!; @channel.admin self end
    def halfop!; @channel.halfop self end
    
    def inspect
      %{#<#{self.class.name} @nickname="#{nickname}" @channel=#{channel}>}
    end
    
    alias_method :to_s, :nickname
  end
end
