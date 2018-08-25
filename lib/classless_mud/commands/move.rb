# frozen_string_literal: true

module ClasslessMud
  module Commands
    module Move
      def self.perform(game, player, message)
        direction = message.split[0]
        found_exit = player.room.exits.detect { |exit| exit.direction == direction }
        room_id = found_exit ? found_exit.target.id : nil
        if room_id
          entering_room = game.world.find_room(room_id)
          exiting_room = player.room

          exiting_room.exit player
          entering_room.enter player

          exiting_room.triggers_for(['exit']).each do |trigger|
            ::ClasslessMud::Lua.new(
              trigger.code,
              player,
              exiting_room,
              game
            ).run!
          end
          entering_room.triggers_for(['enter']).each do |trigger|
            ::ClasslessMud::Lua.new(
              trigger.code,
              player,
              entering_room,
              game
            ).run!
          end
        else
          player.puts "You can't go that way."
        end
      end
    end
  end
end
