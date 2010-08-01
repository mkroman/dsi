module DSI
  class Channel
    attr_accessor :name, :users, :delegate
    
    def initialize name, delegate
      self.name     = name
      self.users    = []
      self.delegate = delegate
      
      delegate.channels.add self
    end
    
    def user_with_name nickname
      @users.select do |user|
        user.nickname == nickname
      end.first
    end
    
    def add prefix
      user = User.new prefix, self
      @users.<< user
      user
    end
    
    def delete nickname
      user = user_with_name(nickname)
      @users.delete user
      user
    end
    
    def say message
      @delegate.say name, message
    end
    
    def mode user, mode
      @delegate.connection.transmit :MODE, name, mode, user.nickname
    end
    
    def     op user; mode user, "+o" end
    def  voice user; mode user, "+v" end
    def  admin user; mode user, "+a" end
    def halfop user; mode user, "+h" end
    
    def inspect
      %{#<#{self.class.name} @name="#{@name}" @users=#{users.map(&:nickname)}>}
    end
    
    alias_method :to_s, :name
  end
end
