module ClasslessMud
  class Client < EventMachine::Connection
    attr_accessor :game
    attr_reader :player

    def initialize
      @logged_in = false
    end

    def post_init
      send_data 'Enter name: '
    end

    def receive_data data
      data = data.chomp
      return login(data) unless @logged_in
      if @callback
        @callback.call(data)
        @callback = nil
        return
      end
      player.handle_message data
    end

    def on &callback
      @callback = callback
    end

    def login name
      @logged_in = true
      @player = Player.accept self, name
      game.add_player player
    end

    def puts message
      send_data "#{message}\n"
    end
  end
end
