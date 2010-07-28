#!/usr/bin/env ruby
# encoding: utf-8
$:.unshift File.dirname(__FILE__) + "/lib"
require 'dsi'

options = {
  hostname: "irc.maero.dk",
  realname: "Mikkel Kroman",
  nickname: "anura"
}

dsi = DSI::Client.new options

dsi.on :ready do
  puts "DSI is now ready to join a channel."
end

dsi.on :message do |message|
  dsi.info "#{message.user.nickname} says: #{message.body}"
end

dsi.connect
