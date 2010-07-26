# encoding: utf-8
require 'dsi/models/user'
require 'dsi/models/channel'
require 'dsi/models/channels'
require 'dsi/misc/logging'
require 'dsi/misc/configuration'
require 'dsi/models/hostmask'
require 'dsi/controller'
$VERBOSE = $VERBOSE.tap do
  $VERBOSE = nil
  require 'methodphitamine'
end
require 'dsi/misc/enhancements'

module DSI
  VERSION = '1.2.0'

  def self.connect options, &block
    controller = Controller.new options
    controller.instance_eval &block
    controller.dispatch :start
    controller.connect
  end
end
