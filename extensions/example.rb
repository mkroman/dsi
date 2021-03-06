config do |c|
  c.name    = "example-extension"
  c.author  = "DSI <dsi@maero.dk>"
  c.version = "0.0.1"
  
  bind :part, :handle_part
  bind :join, :handle_join
end

def handle_join user, channel
  channel.say "Welcome, #{user.nickname}!"
end

def handle_part user, channel
  user.say "Thanks for your visit, please come again."
end
