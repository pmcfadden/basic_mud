module ClasslessMud
  class Game
    def initialize world
      @input_parser = InputParser.new
      @players = []
      @world = world
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
      elsif message == "north"
        valid_exit = player.room.exits.detect {|exit| exit.direction == "north"}
        if valid_exit
          player.room.exit player
          valid_exit.target.enter player
        else
          player.puts "You can't go that way."
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
