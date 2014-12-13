module ClasslessMud
  class Game
    attr_reader :players

    def initialize world
      @players = []
      @world = world
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
