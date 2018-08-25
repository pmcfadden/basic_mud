# frozen_string_literal: true

module ClasslessMud
  class Server
    def initialize(port, game)
      @port = port
      @game = game
    end

    def start
      @signature = EventMachine.start_server('0.0.0.0', @port, ::ClasslessMud::Client) do |client|
        client.start @game
      end
      Thread.new do
        loop do
          @game.tick
          sleep 20
        end
      end
    end

    def stop
      EventMachine.stop_server(@signature)
    end
  end
end
