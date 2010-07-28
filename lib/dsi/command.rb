module DSI
  class Command
    attr_accessor :prefix, :name, :parameters
  
    def initialize name
      self.name = name
    end
    
    def self.parse data
      matches = data.strip.match /^(:(\S+) )?(\S+)(.*)/
      _, prefix, name, parameters = matches.captures
      
      if match = parameters.match(/(?:^:| :)(.*)$/)
        parameters = match.pre_match.split
        parameters << match[1]
      else
        parameters = parameters.split
      end
      
      instance = new name
      instance.prefix = prefix.to_mask if prefix
      instance.parameters = parameters
      instance
    end
    
    def name= name
      if name.is_a? String and name =~ /^\d\d\d$/u
        @name = name.to_i
      else
        @name = name.to_sym
      end
    end
    
    # Messaging
    def message?; @name == :PRIVMSG end
    def to_message
      raise CommandError, "Command is not a valid message" unless message?
      channel, user = Channel[parameters[0], prefix]
      Message.new user, channel, parameters[1]
    end
    
    def to_s
      line = ''
      line << ":#{prefix} " if prefix
      line << name.to_s
      
      parameters.each_with_index do |param, index|
        line << ' '
        line << ':' if index == parameters.length - 1 and param =~ /[ :]/
        line << param
      end
      
      line << "\r\n"
    end
  end
end
