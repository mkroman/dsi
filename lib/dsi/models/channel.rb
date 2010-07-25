# encoding: utf-8

module DSI
  class Channel
    attr_accessor :name, :users
    @@channels = []

    def initialize name, delegate
      @name     = name
      @users    = Array.new
      @delegate = delegate
      @@channels << self
    end

    def say *messages
      messages.each do |message|
        @delegate.say name, message
      end
    end

    def << user
      user.channel = self
      @users << user
    end

    def remove user
      @users.delete user
      user
    end
    
    def kick user, reason = nil
      @delegate.kick @name, user.nickname, reason
    end

    def [] hostmask
      @users.select{ |user| user.nickname == hostmask.nickname }.first
    end

    def user? hostmask
      !@users.select{ |user| user.nickname == hostmask.nickname }.empty?
    end

    def inspect
      %{<DSI::Channel @name="#{name}">}
    end

    def self.list
      @@channels
    end

    def self.[] name
      @@channels.select{ |channel| channel.name == name }.first
    end

  end
end
