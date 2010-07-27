# encoding: utf-8

module DSI
  class User
    attr_accessor :hostmask, :channel

    def initialize hostmask
      @hostmask = hostmask
    end
    
    # Getters
    def nickname; hostmask.nickname.to_nick end
    def username; hostmask.username end
    def hostname; hostmask.hostname end
    
    def admin?
      not @channel.delegate.config.admin?(hostmask).nil?
    end

    # User interaction
    def op!;     @channel.op self end
    def voice!;  @channel.voice self end
    def admin!;  @channel.admin self end
    def halfop!; @channel.halfop self end
    def say message; @channel.delegate.say name, message end
    
    def kick reason = "no reason"
      channel.kick self, reason
    end
    
    def to_s
      %{<#{self.class.name}:#{nickname}>}
    end

    def inspect
      %{<#{self.class.name} @hostmask="#{hostmask}" channel=#{@channel}>}
    end
  end
end
