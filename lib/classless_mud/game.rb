module ClasslessMud
  class Game
    def initialize
      @input_parser = InputParser.new
      @players = []
      @world = World.new
    end

    def add_player player
      @players << player
      @world.add_player player
      self.start_game_for player
    end

    def start_game_for player
      player.puts "game starting"
      @world.starting_room.enter player
      loop do
        input = player.gets
        message = @input_parser.parse(input)
        self.handle_message player, message
      end
    end

    def handle_message player, message
      if message == 'quit'
        player.puts "Are you sure you want to quit? y/n: "
        response = player.gets
        if response == 'y' || response == 'Y'
          player.puts "Thanks for playing"
          player.room.exit player
          player.close_client
        end
      else
        broadcast message
      end
    end

    def broadcast message
      @world.handle_message message
    end
  end
end
