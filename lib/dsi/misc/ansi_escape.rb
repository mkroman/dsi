# encoding: utf-8

class String
  def ansi_escape code
    ANSIEscape[code] + self + ANSIEscape[]
  end

  alias_method :^, :ansi_escape
end

module ANSIEscape
  
  Codes = {
            :bold => '1',
           :reset => '0;0',
           :black => '0;30',
             :red => '0;31',
           :green => '0;32',
           :brown => '0;33',
            :blue => '0;34',
            :cyan => '0;36',
          :purple => '0;35',
      :light_gray => '0;37',
       :dark_gray => '1;30',
       :light_red => '1;31',
     :light_green => '1;32',
          :yellow => '1;33',
      :light_blue => '1;34',
      :light_cyan => '1;36',
    :light_purple => '1;35',
           :white => '1;37',
  } unless defined? Codes

  def self.[] code = :reset
    (sequence = Codes[code]) ? "\033[#{sequence}m" : %%%
  end
end
