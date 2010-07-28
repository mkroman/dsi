require 'digest/md5'
require 'digest/sha1'

config do |c|
  c.name    = "string-tools"
  c.author  = "Mikkel Kroman <mk@maero.dk>"
  c.version = "0.0.1"
  
  bind :privmsg, :handle_string
end

def handle_string user, channel, message
  string = message.params

  case message.command.downcase
  when ".hex"
    channel.say "> #{string.chars.map{ |c| c.unpack 'H*' }.flatten.join(', ')}"
  when ".len"
    channel.say "> Length: #{string.length}"
  when ".upcase"
    channel.say "> #{string.upcase}"
  when ".downcase"
    channel.say "> #{string.downcase}"
  when ".capitalize"
    channel.say "> #{string.capitalize}"
  when ".swapcase"
    channel.say "> #{string.swapcase}"
  when ".squeeze"
    channel.say "> #{string.squeeze}"
  when ".md5"
    channel.say "> #{Digest::MD5.hexdigest message.params}"
  when ".sha", ".sha1"
    channel.say "> #{Digest::SHA1.hexdigest message.params}"
  when ".ord"
    channel.say "> #{string.chars.map(&:ord).join ', '}"
  end
end
