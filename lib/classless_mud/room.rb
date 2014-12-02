module ClasslessMud
  class Room
    include DataMapper::Resource
    property :id, Serial
    has n, :players

    def initialize
      @occupants = []
    end

    def enter player
      broadcast "#{player.name} entered the room"

      @occupants << player
      player.handle_message description
    end

    def broadcast message
      @occupants.each do |occupant|
        occupant.handle_message message
      end
    end

    def description
      "You exit an elevator and glance around.  There's a set of glass double doors to your left and an intersection of hallways to your right"
    end

    def handle_message message
      broadcast message
    end
  end
end
