module DSI
  class Channels
    attr_accessor :delegate
  
    def initialize delegate
      @delegate = delegate
      @channels = []
      # …
    end
    
    def with_name name
      @channels.select do |channel|
        channel.name == name
      end
    end
    
    def with_user nickname
      @channels.select do |channel|
        channel.users.map(&:nickname).include? nickname
      end
    end
    
    def delete_user_from channel, prefix
      with_name(channel).each do |channel|
        yield channel, channel.delete(prefix.nickname)
      end
    end
    
    def add channel
      @channels << channel
    end
    
    def delete channel
      @channels.delete channel
    end
    
    def to_s
      %{#<#{self.class.name} @channels=#{@channels}>}
    end
  end
end
