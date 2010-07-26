module DSI
  class Channels
    @@channels = []
    
    def self.add channel
      @@channels.push channel
    end
    
    def self.delete channel
      @@channels.delete channel
    end
    
    def self.all
      @@channels
    end
    
    def self.with prefix
      @@channels.select{ |channel| channel.user? prefix }
    end
    
    def self.[] name
      @@channels.select{ |channel| channel.name == name }.first
    end
  end
end
