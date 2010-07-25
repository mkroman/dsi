module DSI
  class Configuration

    attr_accessor :nickname, :username, :realname, :hostname

    def initialize options
      @options  = options
      @nickname = options[:nickname]
      @username = options[:username] || @nickname
      @realname = options[:realname] || @username
      @hostname = options[:hostname] or raise "no hostname"
      
      [:nickname, :username, :realname, :hostname, :password].each do |name|
        define_method name do
          @options[name]
        end
      end
      
    end

    def port
      @options[:port] || secure? ? 7000 : 6667
    end

    def secure?
      @options[:secure]
    end

    def password?
      @options[:password]
    end

    def method_missing name, *args
      @options[name]
    end

    def debug?
      options[:verbose] == :debug
    end
  end
end
