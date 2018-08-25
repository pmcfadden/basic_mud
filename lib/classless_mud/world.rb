# frozen_string_literal: true

module ClasslessMud
  class World
    def initialize(rooms)
      @rooms = rooms
    end

    def tick
      @rooms.each(&:tick)
    end

    def add_player(player)
      @players << player
    end

    def find_room(id)
      @rooms.detect { |room| room.id == id }
    end

    def find_room_by_number(number)
      @rooms.detect { |room| room.number == number }
    end

    def starting_room
      @rooms[0]
    end

    def handle_message(message)
      broadcast message
    end

    def add_room(room)
      @rooms << room
    end

    def max_room_number
      @rooms.map(&:number).max
    end

    def broadcast(message)
      @rooms.each do |room|
        room.handle_message message
      end
    end
  end
end
