# encoding: utf-8

module DSI
  class User

    attr_accessor :nickname, :username, :hostmask, :hostname
    alias :name :nickname

    MaskPattern = /^([^\s]+)!([^\s]+)@([a-z0-9\-\.]+)$/iu

    def initialize hostmask
      update hostmask
      @nickname = @nickname.to_nick
    end

    def channel= value
      @channel = value
    end

    def say *messages
      messages.each do |message|
        Extensions.delegate.say name, message
      end
    end
    
    def kick reason = nil
      @channel.kick self, reason
    end

    def update value
      @hostmask = value
      @nickname = value.nickname
      @username = value.username
      @hostname = value.hostname
    end

    def inspect
      %{<DSI::User @nickname="#{@nickname}" @username="#{@username}" @hostname="#{@hostname}" channel=#{@channel}>}
    end

  end
end
