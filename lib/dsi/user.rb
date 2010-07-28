module DSI
  class User
    
    attr_accessor :hostmask # TODO: Rename this
    attr_accessor :channel
    
    def initialize id, channel = nil
      self.hostmask = case id
      when String     then "#{id}!nil@nil".to_mask
      when OpenStruct then id
      end
      self.channel = channel
    end
    
    def say message
      channel.delegate.say nickname, message
    end
    
    def nickname; hostmask.nickname end
    def username; hostmask.username end
    def realname; hostmask.realname end
    def to_s; nickname; end 
    def admin?; false end
    
    def inspect
      %{#<#{self.class.name} @nickname="#{nickname}" @channel=#{channel}>}
    end
  end
end
