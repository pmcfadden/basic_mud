module ClasslessMud
  class Game
    def initialize
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
    end
  end
end
