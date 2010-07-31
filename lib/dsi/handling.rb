module DSI
  module Handling
    def handle command
     debug "#{'<'^:green} #{command}"
    
     case command.name
     when :PRIVMSG
       send_event :message, command
     
     when :PING
       transmit :PONG, command.parameters[0]
       
     when :JOIN
       channels.with_name(command[0]).each do |channel|
         send_event :join, channel, channel.add(command.prefix)
       end
     
     when :PART
       channels.delete_user_from(command[0], command.prefix) do |channel, user|
         send_event :part, channel, user
       end
     
     when 376, 422 # MOTD end or missing
       send_event :ready
       
     when 353 # NAMES list
       _, _, channel, nicks = command.parameters
       synchronize_names channel, nicks
     end
   end
   
 #rescue Exception => exception
   # do something
 
  protected
    def synchronize_names channel, nicks
      channel = (channels.with_name(channel)[0] || Channel.new(channel, @delegate))
    
      nicks.split.each do |nick|
        channel.add nick
      end
    end
    
    def me? prefix
      prefix.nickname == @config.nickname
    end
  end
end
