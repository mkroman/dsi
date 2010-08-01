config do |c|
  c.name    = "ctcp"
  c.author  = "Mikkel Kroman <mk@maero.dk>"
  c.version = "0.0.1"

  bind :ctcp, :on_ctcp
end

def on_ctcp user, message
  if message.ctcp == "VERSION"
    client.notice user.nickname, "\x01VERSION DSI v#{DSI::VERSION}-dev\x01"
  end
end
