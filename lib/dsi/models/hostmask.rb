module DSI
  class Hostmask
    attr_accessor :nickname, :username, :hostname

    MaskPattern = /^([^\s]+)!([^\s]+)@([a-z0-9\-\.]+)$/iu

    def initialize mask
      @nickname, @username, @hostname = *mask
    end
    
    def to_s
      %{<#{self.class.name}:#{@nickname}>}
    end
    
    def inspect
      %{<#{self.class.name} @nickname="#{@nickname}" @username="#{@username}" hostname="#{@hostname}">}
    end

    def self.parse prefix
      result = prefix.match MaskPattern
      result.nil? ? nil : new(result.captures)
    end
  end
end
