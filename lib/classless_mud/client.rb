module ClasslessMud
  MOTD = <<EOS
                  .-~~~~~~~~~-._       _.-~~~~~~~~~-.
              __.'              ~.   .~              `.__
            .'//  We    are       \./    awesome.      \\`.
          .'//                     |                     \\`.
        .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
      .'//.-"                 `-.  |  .-'                 "-.\\`.
    .'//______.============-..   \ | /   ..-============.______\\`.
  .'______________________________\|/______________________________`.
EOS

  class Client < EventMachine::Connection
    attr_reader :player

    def initialize
      @callbacks = []
    end

    def start game
      send_data MOTD
      ::ClasslessMud::AccountBuilder.create(self, game) { |player|
        @player = player
      }
    end

    def receive_data data
      data = data.chomp
      if @callbacks.any?
        callback = @callbacks.pop
        callback.call(data)
        return
      end
      player.handle_message(data)
    end

    def on &callback
      @callbacks.push callback
    end

    def puts message
      send_data "#{message}\n"
    end
  end
end
