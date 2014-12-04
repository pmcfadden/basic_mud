module ClasslessMud
  class Server
    attr_reader :game

    def initialize port, game
      @port = port
      @game = game
    end

    def start
      @signature = EventMachine.start_server('0.0.0.0', @port, ::ClasslessMud::Client) do |con|
        con.game = game
      end
    end

    def stop
      EventMachine.stop_server(@signature)
    end
  end
end
