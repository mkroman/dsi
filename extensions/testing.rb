config do |c|
  c.name = "testing"
  
  bind :privmsg, :handle_message
end

def handle_message user, channel, message
  if message.command == "me"
    channel.say "> #{user.hostmask} || admin: #{user.admin?}"
  end
end
