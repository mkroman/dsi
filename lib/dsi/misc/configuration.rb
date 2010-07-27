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
      @options[:port] || secure? ? 7000 : 6667
    end
    
    def path
      @options[:path]
    end
    
    def admins
      if @options[:admins]
        [@options[:admins]].flatten
      else
        []
      end
    end
    
    def admin? hostmask
      admins.each do |admin|
        return true if Wildcard.match(admin.to_s, hostmask.to_s, true)
      end
      false
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
