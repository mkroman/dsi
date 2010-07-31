#!/usr/bin/env ruby
# encoding: utf-8
$:.unshift File.dirname(__FILE__) + "/lib"
require 'dsi'

options = {
  hostname: "irc.maero.dk",
  realname: "Mikkel Kroman",
  nickname: "anura",
    admins: ['*!*@maero.dk']
}

DSI.connect options do

  on :ready do
    connection.transmit :JOIN, "#test"
  end

  on :message do |message|
    # …
  end
  
  on :join do |channel, user|
    debug "#{user} has joined #{channel}."
  end
  
  on :part do |channel, user|
    debug "#{user} has left #{channel}."
  end
  
end
