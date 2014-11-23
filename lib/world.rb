require_relative "./room.rb"

module ClasslessMud
  class World
    def initialize
      @players = []
      @rooms = [Room.new]
    end

    def add_player player
      @players << player
    end

    def starting_room
      @rooms[0]
    end
  end

end
