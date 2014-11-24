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

    def handle_message message
      broadcast message
    end

    def broadcast message
      @rooms.each do |room|
        room.handle_message message
      end
    end
  end
end
