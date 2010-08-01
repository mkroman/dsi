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
    
    def [] index
      parameters[index]
    end
    
    def name= name
      if name.is_a? String and name =~ /^\d\d\d$/
        @name = name.to_i
      else
        @name = name.to_sym
      end
    end
    
    def sender
      prefix.nickname
    end
    
    def to_message private = false
      Message.new self[1], private
    end
    
    def to_s
      String.new.tap do |line|
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
end
