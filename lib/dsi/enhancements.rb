class String
  ModePattern = /[^@|\+|!|&|~|%].*/

  # Convert a string into a OpenStruct instance containing :nickname, :username
  # and :hostname if it's a user hostname, otherwise it will contain :server.
  def to_mask
    if self =~ /^(\S+)!(\S+)@(\S+)$/
      OpenStruct.new username: $2, hostname: $3, nickname: $1[ModePattern]
    else
      OpenStruct.new server: self
    end
  end
  
  # Return the prefix (0 to length)
  def prefix length = 1
    self[0,length]
  end
  
  # Return the suffix (0 to length)
  def suffix length = 1
    self[-length,length]
  end
end

class OpenStruct
  # We've converted a string into a OpenStruct, now we whould be able to change
  # it back to it's original format again.
  def to_s
    if nickname
      "#{nickname}!#{username}@#{hostname}"
    else
      server
    end
  end
end


class Exception
  def line
    backtrace = exception.backtrace.first
    backtrace = backtrace.match /^(.+?):(\d+)(|:in `(.+)')$/
    backtrace[2].to_s
  end
end
