require 'open-uri'
require 'xmlsimple'

config do |c|
  c.name    = "geoip"
  c.author  = "Mikkel Kroman <mk@maero.dk>"
  c.version = "0.0.1"
  
  bind :privmsg, :geoip
end

def geolocation address
  open("http://ipinfodb.com/ip_query2.php?ip=#{address}&timezone=false") do |response|
    result = XmlSimple.xml_in(response.read)["Location"][0]
    { city: result['City'][0], country: result['CountryName'][0], region: result['RegionName'][0], ip: result['Ip'][0], status: result['Status'][0] }
  end
end

def geoip user, channel, message
  return unless message.command == ".geoip"
  
  location = geolocation message.params
  if location[:status] == "OK"
    channel.say "> GeoIP (#{location[:ip]}): City: #{location[:city]} Country: #{location[:country]} Region: #{location[:region]}"
  else
    channel.say "> GeoIP (#{location[:ip]}): Unknown address."
  end
end
