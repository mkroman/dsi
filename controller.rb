# encoding: utf-8
require 'dsi/connection'

module DSI
  class Controller
    include DSI::Logging

    attr_reader :config

    def initialize options
      @config     = Configuration.new options
      @handlers   = Hash.new
      @connection = Connection.new self
    end

    def connect
      @connection.connect
    end

    def on command, &block
      @handlers[command.to_s] = block if block_given?
    end

    def dispatch command, *args
      if Controller.class_variable_defined? :@@extensions
        Extensions.delegate = self if command == :start
        Extensions.run command, *args
      end
      
      @handlers[command.to_s].call(*args) if @handlers[command.to_s]
    end

    # IRC API
    def join name
      @connection.transmit :JOIN, name.to_chan
    end

    def part name
      @connection.transmit :PART, name.to_chan
    end

    def say recipient, *messages
      messages.each do |message|
        @connection.transmit :PRIVMSG, "#{recipient} :#{message.colorize}"
      end
    end
    
    def mode channel, nickname, mode
      @connection.transmit :MODE, "#{channel} #{mode} #{nickname}"
    end
    
    def kick channel, nickname, reason
      @connection.transmit :KICK, "#{channel} #{nickname} :#{reason}"
    end
    
    def nickname= value
      @config.oldnickname = @config.nickname
      @config.nickname = value
      @connection.transmit :NICK, value
    end

    # getters
    def debug?
      options[:debug]
    end

  end
end

