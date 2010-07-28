$:.unshift File.dirname(__FILE__) + "/../lib"
require 'ostruct'
require 'dsi'

class TestCommand < Test::Unit::TestCase
  
  def test_message
    command = DSI::Command.parse ":mk!mk@maero.dk PRIVMSG #maero :en besked"
    assert_equal OpenStruct.new({ nickname: "mk", username: "mk", hostname: "maero.dk" }), command.prefix
    assert_equal ["#maero", "en besked"], command.parameters
  end
  
end
