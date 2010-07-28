module DSI::Handling

   def handle command
    case command.name
    when :PRIVMSG
      send_event :message, command.to_message
    
    when :PING
      transmit :PONG, command.parameters[0]
      
    when :JOIN
      unless me? command.prefix
        channel = DSI::Channel[command.parameters.first]
        user    = DSI::User.new command.prefix, channel
        channel.users.push user
        send_event :join, user
      end
    
    when :PART
      unless me? command.prefix
        channel, user = DSI::Channel[command.parameters.first, command.prefix]
        channel.users.delete user
        send_event :part, user
      end
    
    when 376, 322 # MOTD end or missing
      send_event :ready
      
    when 353 # NAMES list
      _, _, channel_name, nicks = command.parameters
      synchronize channel_name, nicks
    end
    
    if DSI::Client.class_variable_defined? :@@extensions
      DSI::Extensions.run command
      DSI::Extensions.delegate = @delegate
    end
  end
  
  def synchronize channel_name, nicks
    channel = (DSI::Channel[channel_name] || DSI::Channel.new(channel_name, @delegate))
  
    nicks.split.each do |nick|
      channel.users.push DSI::User.new(nick, channel)
    end
  end
  
  def me? prefix
    prefix.nickname == @config.nickname
  end
end
