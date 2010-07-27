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
      emit :connection

      begin
        main_loop
      rescue Interrupt
        emit :disconnecting, "Interrupted by user."
      end
    end

    def terminate
      return unless connected?

      @socket.close
      @connected = false
      emit :disconnecting, "Terminated by user"
    end

    def main_loop
      until @socket.eof? do
        command = Command.parse @socket.gets
        
        debug "#{'<'^:green} #{command.name.to_s.ljust(7)^:bold} : #{command.parameters.join ' '}"
        
        if respond_to? "got_#{command.name.to_s.downcase}"
          send "got_#{command.name.to_s.downcase}", command.prefix, command.parameters
        end
      end
    end
    
    def got_ping prefix, server
      transmit :PONG, server.first
    end
    
    def got_privmsg prefix, params
      channel, message = params
      
      if me? channel
        emit :private_message, prefix, message
      else
        channel, user = find_user(channel, prefix)
        user.hostmask = prefix
        emit :message, user, channel, message
      end
    end
    
    def got_quit prefix, nickname, *reason
      Channels.with(prefix).each do |channel|
        user = channel.user(prefix)
        emit :quit, user
        channel.delete user
      end
    end
    
    def got_join prefix, params
      channel = params.first
    
      unless me? prefix
        user = User.new prefix
        channel = Channels[channel].add(user)
        emit :join, channel, user
      end
    end
    
    def got_part prefix, params
      channel = params.first
      
      unless me? prefix
        channel, user = find_user(channel, prefix)
        channel.delete user
        emit :part, channel, user
      end
    end
    
    # RPL_NAMREPLY
    def got_353 prefix, params
      _, _, name, nicks = params
      channel = Channels[name] || Channel.new(name, @delegate)
      
      nicks.split.each do |nick|
        unless me? nick
          channel.add User.new("#{nick}!nil@nil".mask)
        end
      end
    end
    
    # ERR_ERRONEUSNICKNAME
    def got_432 prefix, nickname, *message
      @delegate.config.nickname = @delegate.config.oldnickname
      emit :error, Errors[432]
    end
    
    # ERR_NICKNAMEINUSE
    def got_433 prefix, nickname, *message
      @delegate.config.nickname = @delegate.config.oldnickname
      emit :error, Errors[433]
    end
    
    def got_nick prefix, value
      Channels.with(prefix).each do |channel|
        user = channel.user prefix
        oldnick = user.nickname
        user.hostmask.nickname = value
        emit :nick, channel, user, oldnick
      end
    end
    
    def got_376 *args; emit :ready end
    def got_422 *args; emit :ready end

    def transmit command, params
      output = [command, params].join ' '
      debug "#{'>'^:red} #{command.to_s.ljust(7)^:bold} : #{params}"
      @socket.puts output
    end

    def connected?
      @connected
    end

  private
    def find_user name, prefix
      channel = Channels[name]
      return channel, channel.user(prefix)
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
      transmit :USER, "#{@delegate.config.username} nil nil :#{@delegate.config.realname}"
    end

  end
end

