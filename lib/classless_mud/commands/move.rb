module ClasslessMud
  module Commands
    class Move
      def self.perform player, message
        direction = message.split[0]
        valid_exit = player.room.exits.detect {|exit| exit.direction == direction}
        if valid_exit
          player.room.exit player
          valid_exit.target.enter player
        else
          player.puts "You can't go that way."
        end
      end
    end
  end
end
