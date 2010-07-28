# encoding: utf-8
require 'json'
require 'open-uri'

config do |x|
  x.name    = "Google"
  x.author  = "Mikkel Kroman <mk@maero.dk>"
  x.version = "1.0.0"
  
  bind :privmsg, :google
end

def search query
  open "http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{URI.escape query}" do |response|
    results = JSON.parse(response.read)["responseData"]["results"]
    result = results.first
    
    if result
      [result["titleNoFormatting"], result["unescapedUrl"]]
    else
      nil
    end
  end
end

def google user, channel, message
  return unless message.command == ".g"
  
  title, url = search message.body.split(" ", 2)[1]
  
  if title
    channel.say "> #{title} - #{url}"
  else
    channel.say "> No results."
  end
end
