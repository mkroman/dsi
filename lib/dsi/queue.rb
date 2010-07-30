module DSI
  class Queue
  
    @commands = []
  
    def initialize output = $stdout
      @output = output
    end
    
    def << command
      @@commands << command
    end
    
    def start
      loop do
        # process…
      end
    end
  end
end
