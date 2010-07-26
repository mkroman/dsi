# encoding: utf-8

module DSI
  class Channel
    attr_accessor :name, :users, :delegate

    def initialize name, delegate
      @name     = name
      @users    = []
      @delegate = delegate
      
      Channels.add self
    end

    # Methods only used by DSI.
    def add user
      user.channel = self
      @users.push user
      self
    end
    
    def delete user
      users.delete user
      self
    end
    
    # Channel interaction
    def say message; @delegate.say name, message end
    def op user;     @delegate.mode name, user.nickname, "+o" end
    def voice user;  @delegate.mode name, user.nickname, "+v" end
    def admin user;  @delegate.mode name, user.nickname, "+a" end
    def halfop user; @delegate.mode name, user.nickname, "+h" end
    
    def kick user, reason = "no reason"
      @delegate.kick name, user.nickname, reason
    end

    # "Finders"
    def user prefix
      @users.select{ |user| user.nickname == prefix.nickname }.first
    end

    def user? prefix
      !@users.select{ |user| user.nickname == prefix.nickname }.empty?
    end
    
    def to_s
      %{<#{self.class.name}:#{name}>}
    end

    def inspect
      %{<#{self.class.name} @name="#{name}">}
    end
  end
end
