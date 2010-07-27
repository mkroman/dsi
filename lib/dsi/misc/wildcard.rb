# encoding: utf-8

module Wildcard
  def self.match pattern, source, casefold = false
    pattern = compile pattern.dup, casefold
    pattern.match source
  end
  
protected
  def self.compile pattern, casefold
    ['.', '[', ']', '(', ')'].each do |reserved|
      pattern.gsub! reserved, '\\' + reserved
    end
    pattern.gsub! '?', '.'
    pattern.gsub! '*', '.*?'
    
    if casefold
      Regexp.compile pattern, Regexp::IGNORECASE
    else
      Regexp.compile pattern
    end
  end
end
