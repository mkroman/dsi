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
      @admins   = options[:admins] || []
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
    
    def admin? hostmask
      @admins.each do |admin|
        return true if Wildcard.match(admin, hostmask.to_s, true)
      end
      false
    end

    def debug?
      options[:verbose] == :debug
    end
    
    def method_missing name, *arguments
      @options[name]
    end
  end
end
