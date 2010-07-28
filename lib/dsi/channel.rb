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
    
    def say message
      @delegate.say name, message
    end
    
    def with prefix
      [self, users.select{ |u| u.nickname == prefix.nickname }.first]
    end
    
    def inspect
      %{#<#{self.class.name} @name={@name} @users=#{users.map(&:nickname)}>}
    end
    
  end
end
