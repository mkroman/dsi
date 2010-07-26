Example
-------
    #!/usr/bin/env ruby
    require 'dsi'
    require 'dsi/extensions'

    options = {
      hostname: 'irc.maero.dk',
      nickname: 'anura'
    }

    DSI.connect options do

      on :start do
        Extensions.autoload
      end

      on :message do |user, channel, message|
        if user.nickname == "mk" and message == ".reload"
          Extensions.reload
          channel.say "> Extensions successfully reloaded." ^ :cyan
        end
      end
      
      on :join do |channel, user|
        channel.say "Welcome to #{channel.name}, #{user.nickname}!"
      end
      
      on :part do |channel, user|
        debug "Aww, #{user.nickname} left #{channel.name}!"
      end

      on :nick do |channel, user, old_nickname|
        channel.say "#{user.nickname}: what was wrong with #{old_nickname}?"
      end

      on :ready do
        join :maero
      end

    end
    
Extension Example
-----------------
    @triggers = %w{.d .t .time .date}

    def init user, channel, message
      say channel, "> #{%x{date}}" ^ :cyan
    end
