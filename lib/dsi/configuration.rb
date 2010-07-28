module DSI
  class Configuration
    attr_accessor :nickname, :username, :realname, :hostname, :password,
    :oldnickname

    def initialize options
      @options  = options
      @nickname = options[:nickname]
      @username = options[:username] || @nickname
      @realname = options[:realname] || @username
      @password = options[:password]
      @hostname = options[:hostname] or raise "no hostname"
    end

    def port
      @options[:port] || secure? ? 6697 : 6667
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
