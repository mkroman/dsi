config do |c|
  c.name = "testing"
  
  bind :privmsg, :on_privmsg
end

def on_privmsg user, channel, message
  return unless message.command == ".thread"
  
  Thread.new do
    sleep 5
    channel.say "> 5 seconds later"
  end
  
  channel.say "> instantly"
end
