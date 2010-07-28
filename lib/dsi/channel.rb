module DSI
  class Channel
  
    attr_accessor :name, :users, :delegate
    
    @@channels = []
    
    def initialize name, delegate
      self.name     = name
      self.users    = []
      self.delegate = delegate
      
      @@channels.push self
    end
    
    def self.[] name, prefix = nil
      if prefix
        self[name].with prefix
      else
        @@channels.select{ |channel| channel.name == name }.first
      end
    end
    
    def self.with prefix
      channels = @@channels.select{ |channel| channel.user? prefix }
      channels.map{ |c| c.with prefix }.compact!
    end
    
    def say message
      @delegate.say name, message
    end
    
    def user? prefix
      self.users.select{ |user| user.nickname == prefix.nickname }
    end
    
    def with prefix
      user = @users.select{ |u| u.nickname == prefix.nickname }.first
      if user
        [self, user]
      else
        return
      end
    end
    
    def inspect
      %{#<#{self.class.name} @name=#{@name} @users=#{users.map(&:nickname)}>}
    end
    
  end
end
