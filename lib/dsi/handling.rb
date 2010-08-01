module DSI
  module Handling
    def handle command
     debug "#{'<'^:green} #{command}"
    
     case command.name
     when :PRIVMSG
       if command[0] == @config.nickname
         message = command.to_message true
         if message.ctcp?
           send_event :ctcp_request, command.prefix, message
           extensions.run :ctcp, command.prefix, message
         else
           send_event :private_message, command.prefix, message
           extensions.run :privmsg, nil, command.prefix, message
         end
       else
         channels.with_user_in(command[0], command.sender) do |channel, user|
           user.prefix = command.prefix
           send_event :message, user, channel, command.to_message
           extensions.run :privmsg, user, channel, command.to_message
         end
       end
     
     when :PING
       transmit :PONG, command.parameters[0]
       
     when :JOIN
       channels.with_name(command[0]).each do |channel|
         user = channel.add command.prefix
         send_event :join, user, channel
         extensions.run :join, user, channel
       end
     
     when :PART
       channels.delete_user_from(command[0], command.prefix) do |user, channel|
         send_event :part, user, channel
         extensions.run :part, user, channel
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

    def extensions
      @delegate.extensions
    end
  end
end
