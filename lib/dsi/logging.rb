# encoding: utf-8

module DSI
  module Logging

    Levels      = [:debug, :info, :warn, :fatal]
    LevelColors = { debug: :white, info: :blue, warn: :light_red, fatal: :yellow }

    def self.log level, *messages
      messages.each do |message|
        $stdout.puts format(level, message)
      end
    end

    Levels.each do |level|
      define_method level do |*messages|
        Logging.log level, *messages
      end
    end

    protected
    def self.format level, message
      [timestamp, level_string(level), "#{message}"].join " "
    end

    def self.level_string level
      max_width = Levels.map(&:length).max
      level.to_s.capitalize.rjust(max_width) ^ LevelColors[level]
    end

    def self.timestamp
      Time.now.strftime "%H:%M:%S"
    end

  end
end

