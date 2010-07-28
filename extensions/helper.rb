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
  
  case params.first
  when "list"
    channel.say "> Extensions: #{Extensions.all.join ', '}"
    
  when "load"
    extension = Extension.new(params[1])
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
    if extension = Extensions[params[1]]
      channel.say "> Extension: #{extension.name} (#{extension.version}) by #{extension.author}"
    else
      channel.say "> Extension not found: #{params[1]}."
    end
    
  when "reload"
    if Extensions.reload
      channel.say "> Successfully reloaded."
    else
      channel.say "> Could not reload extensions."
    end
  end
end
