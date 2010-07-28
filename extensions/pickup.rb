config do |c|
  c.name    = "pickup"
  c.author  = "Mikkel Kroman"
  c.version = "0.0.1"
  
  bind :part,    :handle_part
  bind :join,    :handle_join
  bind :privmsg, :handle_message
end

@contenders = []

def handle_message user, channel, message
  case message.command
  when ".signup"
    unless @contenders.include? user
      @contenders << user
      channel.say "> #{user.nickname} has been added to the pickup list"
    else
      channel.say "> #{user.nickname} is already on the pickup list"
    end
    
  when ".remove"
    if @contenders.delete user
      channel.say "> #{user.nickname} has been deleted from the pickup list"
    else
      channel.say "> #{user.nickname} is not on the pickup list"
    end
    
  when ".contenders"
    channel.say "> Contenders (#{@contenders.length}): #{@contenders.map(&:nickname).join ', '}"
  end
end

def handle_join user, channel
  # do nothing as of yet…
end

def handle_part user, channel
  if @players.delete user
    channel.say "> #{user.nickname} has been removed from the pickup list."
  end
end
