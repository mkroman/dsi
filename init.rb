#!/usr/bin/env ruby
# encoding: utf-8
$:.unshift File.dirname(__FILE__) + "/lib"
require 'dsi/extensions'
require 'dsi'

options = {
  hostname: "irc.maero.dk",
  realname: "Mikkel Kroman",
  nickname: "anura",
    admins: ['*!*@maero.dk', '*!*@*cybercity.dk']
}

dsi = DSI::Client.new options
dsi.hook do

  on :ready do
    connection.transmit :JOIN, "#test"
    DSI::Extensions.autoload
  end

  on :message do |message|
    debug "[#{message.channel.name^:bold}] #{message.user.nickname^:light_green}: #{message.body}"
  end
  
end

dsi.connect
