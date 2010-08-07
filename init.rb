#!/usr/bin/env ruby
# encoding: utf-8
$:.unshift File.dirname(__FILE__) + "/lib"
require 'dsi'

options = {
  hostname: "irc.maero.dk",
  realname: "Mikkel Kroman",
  nickname: "anura",
      port: 6668,
    admins: ['*!*@maero.dk']
}

DSI.connect options do

  on :start do
    extensions.load
  end

  on :ready do
    connection.transmit :JOIN, "#test"
  end

  on :message do |user, channel, message|
    debug "[#{channel.to_s^:light_green}] #{user.to_s^:bold}: #{message.body}"
  end

  on :private_message do |user, message|
    debug "#{user.nickname^:bold}: #{message.body.inspect}"
  end

  on :ctcp_request do |user, message|
    debug "CTCP Request from #{user.to_s^:bold}: #{message.ctcp.inspect}"
  end
  
  on :join do |channel, user|
    debug "#{user.to_s^:bold} has joined #{channel.to_s^:bold}."
  end
  
  on :part do |channel, user|
    debug "#{user.to_s^:bold} has left #{channel.to_s^:bold}."
  end
  
end
