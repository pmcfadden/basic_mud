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
      player.puts "game starting"
      @world.starting_room.enter player
    end

    def broadcast message
      @world.handle_message message
    end
  end
end
