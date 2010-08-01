# encoding: utf-8
require 'socket'
require 'ostruct'
require 'dsi/ansi'
require 'dsi/user'
require 'dsi/logging'
require 'dsi/client'
require 'dsi/channel'
require 'dsi/message'
require 'dsi/command'
require 'dsi/channels'
require 'dsi/wildcard'
require 'dsi/handling'
require 'dsi/extensions'
require 'dsi/connection'
require 'dsi/enhancements'
require 'dsi/configuration'

module DSI
  VERSION = '0.0.4'
  
  def self.connect options, &p
    client = DSI::Client.new options
    client.instance_eval &p
    client.send_event :start
    client.connect
  end
end
