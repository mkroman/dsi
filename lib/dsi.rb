# encoding: utf-8
require 'dsi/models/user'
require 'dsi/models/channel'
require 'dsi/models/channels'
require 'dsi/command'
require 'dsi/misc/wildcard'
require 'dsi/misc/logging'
require 'dsi/misc/configuration'
require 'dsi/models/hostmask'
require 'dsi/controller'
require 'dsi/misc/enhancements'

module DSI
  VERSION = '1.3.0'

  def self.connect options, &block
    instance = Controller.new options
    instance.instance_eval &block
    instance.dispatch :start
    instance.connect
  end
end
