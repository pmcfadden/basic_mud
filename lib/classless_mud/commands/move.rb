module ClasslessMud
  module Commands
    class Move
      def self.perform game, player, message
        direction = message.split[0]
        found_exit = player.room.exits.detect {|exit| exit.direction == direction}
        room_id = found_exit ? found_exit.target.id : nil
        if room_id
          valid_exit = game.world.find_room(room_id)
          player.room.exit player
          valid_exit.enter player
        else
          player.puts "You can't go that way."
        end
      end
    end
  end
end

