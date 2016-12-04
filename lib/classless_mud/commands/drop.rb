module ClasslessMud
  module Commands
    class Drop
      def self.perform game, player, message
        _, drop_target = message.split " ", 2
        found = drop_target ? player.find_in_inventory(drop_target) : false
        if found
          player.items.delete found
          player.room.items << found
          player.room.broadcast "#{player.name} drops #{found.name}."
          player.puts "You drop #{found.name}."
          found.triggers_for([:drop]).each do |trigger|
            ::ClasslessMud::Lua.new(
              trigger.code,
              player,
              player.room,
              game
            ).run!
          end
        else
          player.puts "That doesn't seem to be in your inventory."
        end
      end
    end
  end
end
