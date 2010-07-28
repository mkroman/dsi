module DSI::Handling

   def handle command
    case command.name
    when :PRIVMSG
      send_event :message, command.to_message
    
    when :PING
      transmit :PONG, command.parameters[0] 
    
    when 376, 322 # MOTD end or missing
      send_event :ready
      
    when 353 # NAMES list
      _, _, channel_name, nicks = command.parameters
      synchronize channel_name, nicks
    end
  end
  
  def synchronize channel_name, nicks
    channel = (DSI::Channel[channel_name] || DSI::Channel.new(channel_name))
  
    nicks.split.each do |nick|
      channel.users.push DSI::User.new(nick, channel)
    end
  end
end
