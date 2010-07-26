module DSI
  class Configuration
    attr_accessor :nickname, :username, :realname, :hostname, :oldnickname

    def initialize options
      @options  = options
      @nickname = options[:nickname]
      @username = options[:username] || @nickname
      @realname = options[:realname] || @username
      @hostname = options[:hostname] or raise "no hostname"
    end

    def port
      @options[:port] || secure? ? 7000 : 6667
    end
    
    def path
      @options[:path]
    end

    def secure?
      !@options[:secure].nil?
    end

    def password?
      !@options[:password].nil?
    end

    def debug?
      options[:verbose] == :debug
    end
  end
end
