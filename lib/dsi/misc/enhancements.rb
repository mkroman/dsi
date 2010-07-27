# encoding: utf-8

class String

  ANSIColors = {
    "\033[1m"    => "\x0F",
    "\033[0;0m"  => "\x0310",
    "\033[0;30m" => "\x0301",
    "\033[0;31m" => "\x0305",
    "\033[0;32m" => "\x0303",
    "\033[0;33m" => "\x0307",
    "\033[0;34m" => "\x0305",
    "\033[0;36m" => "\x0310",
    "\033[0;35m" => "\x0306",
    "\033[0;37m" => "\x0315",
    "\033[1;30m" => "\x0314",
    "\033[1;31m" => "\x0304",
    "\033[1;32m" => "\x0309",
    "\033[1;33m" => "\x0308",
    "\033[1;34m" => "\x0310",
    "\033[1;36m" => "\x0311",
    "\033[1;35m" => "\x0313",
    "\033[1;37m" => "\x03\x02\x02"
  }

  def strip_ansi
    self.gsub! /\033\[[\d;]+m/u, ''
  end

  def to_utf8!
    p Encoding.default_internal
    p Encoding.default_external
    self.encode 'utf-8'
  end

  def colorize
    gsub(/\033\[([\d;]+)m/u) do |color|
      ANSIColors[color] or ""
    end
  end

  def colorize!
    replace colorize
  end

  def to_chan
    self
  end

  def to_nick
    gsub /^@|\+|~|&/u, ''
  end

  def mask
    DSI::Hostmask.parse self
  end
end

class Exception
  def line
    backtrace = exception.backtrace.first
    backtrace.match(/^(.+?):(\d+)(|:in `(.+)')$/u)[2]
  end
end

class Array
  def to_chan
    join ','
  end
end

class Symbol
  def to_chan
    "#" + to_s
  end
end
