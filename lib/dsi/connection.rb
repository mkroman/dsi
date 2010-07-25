# encoding: utf-8
require 'socket'
require 'openssl'

module DSI
  class Connection
    include DSI::Logging

    Errors = {
      401 => :ERR_NOSUCHNICK,         402 => :ERR_NOSUCHSERVER,
      403 => :ERR_NOSUCHCHANNEL,      404 => :ERR_CANNOTSENDTOCHAN,
      405 => :ERR_TOOMANYCHANNELS,    406 => :ERR_WASNOSUCHNICK,
      407 => :ERR_ERR_TOOMANYTARGETS, 409 => :ERR_NOORIGIN,
      411 => :ERR_NORECIPIENT,        412 => :ERR_NOTEXTTOSEND,
      413 => :ERR_NOTOPLEVEL,         414 => :ERR_WILDTOPLEVEL,
      421 => :ERR_UNKNOWNCOMMAND,     422 => :ERR_NOMOTD,
      423 => :ERR_NOADMININFO,        424 => :ERR_FILEERROR,
      431 => :ERR_NONICKNAMEGIVEN,    432 => :ERR_ERRONEUSNICKNAME,
      433 => :ERR_NICKNAMEINUSE,      436 => :ERR_NICKCOLLISION,
      441 => :ERR_USERNOTINCHANNEL,   442 => :ERR_NOTONCHANNEL,
      443 => :ERR_USERONCHANNEL,      444 => :ERR_NOLOGIN,
      445 => :ERR_SUMMONDISABLED,     446 => :ERR_USERSDISABLED,
      451 => :ERR_NOTREGISTERED,      461 => :ERR_NEEDMOREPARAMS,
      462 => :ERR_ALREADYREGISTRED,   463 => :ERR_NOPERMFORHOST,
      464 => :ERR_PASSWDMISMATCH,     465 => :ERR_YOUREBANNEDCREEP,
      467 => :ERR_KEYSET,             471 => :ERR_CHANNELISFULL,
      472 => :ERR_UNKNOWNMODE,        473 => :ERR_INVITEONLYCHAN,
      474 => :ERR_BANNEDFROMCHAN,     475 => :ERR_BADCHANNELKEY,
      481 => :ERR_NOPRIVILEGES,       482 => :ERR_CHANOPRIVSNEEDED,
      483 => :ERR_CANTKILLSERVER,     491 => :ERR_NOOPERHOST,
      501 => :ERR_UMODEUNKNOWNFLAG,   502 => :ERR_USERSDONTMATCH
    }

    LinePattern = /^(?::([^ ]+) +)?([^:][^ ]*)(?: ([^: ][^ ]*))*(?: :(.*))? *[\r\n]+$/u

    def initialize controller
      @delegate  = controller
      @connected = false
    end

    def establish
      return if connected?
      @socket = TCPSocket.new @delegate.config.hostname, @delegate.config.port

      if @delegate.config.secure?
        @socket = OpenSSL::SSL::SSLSocket.new @socket, OpenSSL::SSL::SSLContext.new
        @socket.connect
      end

      register
      @connected = true
      @delegate.dispatch :connect

      begin
        main_loop
      rescue Interrupt
        @delegate.dispatch :disconnect, "Interrupted by user."
      end
    end

    def terminate
      return unless connected?

      @socket.close
      @connected = false
      @delegate.dispatch :disconnect, "Terminated by user"
    end

    def main_loop
      until @socket.eof? do
        prefix, command, *params = parse(line = @socket.gets)
        params.compact!
        
        prefix = (prefix.nil? ? prefix : prefix.mask)
        
        debug "#{'←'^:green} #{command.ljust(7)^:bold} : #{params.join ' '}"
        
        if respond_to? "got_#{command.downcase}"
          send "got_#{command.downcase}", prefix, *params
        end
      end
    end
    
    def got_ping prefix, server
      transmit :PONG, server
    end
    
    def got_privmsg prefix, channel, message
      if me? channel
        emit :private_message, prefix, message
      else
        channel, user = find_user(channel, prefix)
        emit :message, user, channel, message
      end
    end
    
    def got_quit prefix, nickname, *reason
      channels = Channel.list.select{ |channel| channel.user? prefix }
      
      channels.each do |channel|
        user = channel[prefix]
        emit :quit, user
        channel.remove user
      end
    end
    
    def got_join prefix, channel
      unless me? prefix
        channel = Channel[channel]
        channel << (user = User.new(prefix))
        emit :join, channel, user
      end
    end
    
    def got_part prefix, channel
      unless me? prefix
        channel, user = find_user(channel, prefix)
        channel.remove user
        emit :part, user, channel
      end
    end
    
    def got_353 prefix, name, nicks
      channel = Channel[name] || Channel.new(name, @delegate)
      
      nicks.split.each do |nick|
        unless me? nick
          channel << User.new("#{nick}!nil@nil".mask)
        end
      end
    end
    
    def got_nick prefix, value
      channels = Channel.list.select{ |channel| channel.user? prefix }
      
      channels.each do |channel|
        user = channel[prefix]
        emit :nick, channel, user, value
        user.nickname = value
      end
    end
    
    def got_376 *args; emit :ready end
    def got_422 *args; emit :ready end

    def transmit command, params
      output = [command, params].join ' '
      debug "#{'→'^:red} #{command.to_s.ljust(7)^:bold} : #{params}"
      @socket.puts output
    end

    def connected?
      @connected
    end

    private
    def parse line
      line.to_utf8!
      result = line.match LinePattern
      
      if result
        result.captures
      else
        [":local", "ERROR", "Could not parse line"]
      end
    end

    def find_user name, hostmask
      channel = Channel[name]
      return channel, channel[hostmask]
    end
    
    def me? who
      if who.is_a? Hostmask
        who.nickname == @delegate.config.nickname
      elsif who.is_a? String
        who.to_nick == @delegate.config.nickname
      end
    end
    
    def emit name, *args
      @delegate.dispatch name, *args
    end

    def register
      transmit :PASS, @delegate.config.password if @delegate.config.password?
      transmit :NICK, @delegate.config.nickname
      transmit :USER, "#{@delegate.config.username} na na :#{@delegate.config.realname}"
    end

  end
end

