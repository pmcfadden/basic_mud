module ClasslessMud
  module Commands
    class Recall
      # TODO: Add player-specific recall locations
      RECALL_ROOM = 3

      def self.perform game, player, message
        player.puts "Are you sure you want to recall? y/n: "
        player.on do |recall_response|
          if recall_response == 'y' || recall_response == 'Y'
            player.puts 'Recalling...'
            recall_room = game.world.find_room(RECALL_ROOM)
            if recall_room
              player.room.exit player
              recall_room.enter player, "#{player.name} appears in a blinding blue light."
            else
              player.puts 'Recall room does not exist. Please contant the admin.'
            end
          end
        end
      end
    end
  end
end

