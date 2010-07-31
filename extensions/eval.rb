config do |c|
  c.name    = "eval"
  c.author  = "Mikkel Kroman <mk@maero.dk>"
  c.version = "0.0.1"
  
  bind :privmsg, :on_privmsg
end

def on_privmsg user, channel, message
  return unless message.command == bot.config.nickname + ?:
  
  if message.params.start_with? "eval "
    if user.admin?
      channel.say "=> #{eval(message.params[5..-1]) || nil}"
    else
      channel.say "> #{user}: >8("
    end
  end
  
rescue Exception => exception
  channel.say "> #{exception.message}"
end
