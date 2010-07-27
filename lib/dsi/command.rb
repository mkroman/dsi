module DSI
  class Command
    attr_accessor :prefix, :name, :parameters
  
    def initialize name
      self.name = name
    end
    
    def name= name
      if name.is_a? String and name =~ /^\d\d\d$/u
        @name = name.to_i
      else
        @name = name.to_sym
      end
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
      instance.prefix = prefix.mask if prefix
      instance.parameters = parameters
      instance
    end
  end
end
