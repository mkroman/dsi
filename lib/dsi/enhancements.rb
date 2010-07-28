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
