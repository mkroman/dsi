module DSI
  class Channel
  
    attr_accessor :name, :users
    
    @@channels = []
    
    def initialize name
      self.name  = name
      self.users = []
      
      @@channels.push self
    end
    
    def self.[] name, prefix = nil
      if prefix
        self[name].with prefix
      else
        @@channels.select{ |channel| channel.name == name }.first
      end
    end
    
    def with prefix
      [self, users.select{ |u| u.nickname == prefix.nickname }.first]
    end
    
    def inspect
      %{#<#{self.class.name} @name={name} @users=#{users.map(&:nickname)}>}
    end
    
  end
end
