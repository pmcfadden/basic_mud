module ClasslessMud
  class Game
    attr_reader :players
    attr_reader :settings

    def initialize world, settings
      @players = []
      @world = world
      @settings = settings
    end

    def add_player player
      @players << player
      @world.add_player player
      @world.starting_room.enter player
      broadcast "#{player.name} has joined the game."
    end

    def remove_player player
      @players.delete player
      broadcast "#{player.name} has left the game."
    end

    def broadcast message
      @world.handle_message message
    end

    def display_players player
      player.puts <<EOS
Currently active players
------------------------
#{@players.map(&:name).join("\n")}
EOS
    end
  end
end
