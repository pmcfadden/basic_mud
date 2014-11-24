module ClasslessMud
  class Room
    def initialize
      @occupants = []
    end

    def enter player
      broadcast "#{player.name} entered the room"

      @occupants << player
      player.handle_message description
      while @occupants.include? player
        message = player.gets
        handle_message player, message
      end
    end

    def broadcast message
      @occupants.each do |occupant|
        occupant.handle_message message
      end
    end

    def description
      "You exit an elevator and glance around.  There's a set of glass double doors to your left and an intersection of hallways to your right"
    end

    def handle_message player, message
      if message == 'quit'
        player.puts "Are you sure you want to quit? y/n: "
        response = player.gets
        if response == 'y' || response == 'Y'
          player.puts "Thanks for playing"
          player.close_client
          @occupants.delete(player)
          @occupants.handle_message("#{player.name} left the world")
        end
      else
        broadcast message
      end
    end
  end
end
