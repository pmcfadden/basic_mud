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
      starting_room.enter player unless player.room_id
      broadcast "#{player.name} has joined the game."
    end

    def starting_room
      @world.starting_room
    end

    def remove_player player
      player.room.exit player
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
