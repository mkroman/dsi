# encoding: utf-8

config do |x|
  x.name    = "helper"
  x.author  = "Mikkel Kroman <mk@maero.dk>"
  x.version = "0.0.1"
  
  bind :privmsg, :handle_extensions
end

def handle_extensions user, channel, message
  return unless message.command == client.config.nickname + ?:
  params = message.params.split
  
  if user.admin?
    case message.param 0
    when "list"
      channel.say "> Extensions: #{client.extensions.all.join ', '}"
      
    when "load"
      extension = client.extension.new(client.extensions, params[1])
      if extension.name
        channel.say "> Loaded extension #{extension.name}."
      else
        channel.say "> Could not load extension #{params[1]}."
      end

    when "unload"
      if extension = Extensions[params[1]]
        if extension.unload!
          channel.say "> Unloaded #{extension.name}."
        end
      else
        channel.say "> Extension not found: #{params[1]}."
      end
      
    when "info"
      if extension = client.extensions[params[1]]
        channel.say "> Extension: #{extension.name} (#{extension.version}) by #{extension.author}"
      else
        channel.say "> Extension not found: #{params[1]}."
      end
      
    when "reload"
      if client.extensions.reload
        channel.say "> Successfully reloaded."
      else
        channel.say "> Could not reload extensions."
      end
    end
  else
    channel.say "> access denied"
  end
end
