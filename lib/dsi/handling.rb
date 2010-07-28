module DSI::Handling

   def handle command
    case command.name
    when :PRIVMSG
      message = command.to_message
      message.user.hostmask = command.prefix
      rext command, message.user, message.channel, message
      send_event :message, message
    
    when :PING
      rext command, command.parameters[0]
      transmit :PONG, command.parameters[0]
      
    when :JOIN
      unless me? command.prefix
        channel = DSI::Channel[command.parameters.first]
        user    = DSI::User.new command.prefix, channel
        channel.users.push user
        rext command, user, channel
        send_event :join, user
      end
    
    when :PART
      unless me? command.prefix
        channel, user = DSI::Channel[command.parameters.first, command.prefix]
        channel.users.delete user
        rext command, user, channel
        send_event :part, user
      end
      
    when :NICK
      unless me? command.prefix
        DSI::Channel.with(command.prefix).each do |channel, user|
          user.hostmask.nickname = command.parameters[0]
          rext command, user, channel, command.prefix.nickname
        end
      end
    
    when 376, 322 # MOTD end or missing
      send_event :ready
      
    when 353 # NAMES list
      _, _, channel_name, nicks = command.parameters
      synchronize channel_name, nicks
      
    else
      if DSI::Client.class_variable_defined? :@@extensions
        rext command
        DSI::Extensions.delegate = @delegate
      end
    end
  end
  
protected
  def synchronize channel_name, nicks
    channel = (DSI::Channel[channel_name] || DSI::Channel.new(channel_name, @delegate))
  
    nicks.split.each do |nick|
      channel.users.push DSI::User.new(nick, channel)
    end
  end
  
  def rext *args
    if DSI::Client.class_variable_defined? :@@extensions
      DSI::Extensions.run *args
    end
  end
  
  def me? prefix
    prefix.nickname == @config.nickname
  end
end
