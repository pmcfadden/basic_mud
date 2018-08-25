module ClasslessMud
  module Commands
    class Get
      def self.perform(game, player, message)
        _, get_target = message.split ' ', 2
        found = get_target ? player.room.find(get_target) : false
        if found
          player.items << found
          player.room.items.delete found
          player.items.save!
          player.room.broadcast "#{player.name} picks up #{found.name}"
          player.puts "You pick up #{found.name}"
          found.triggers_for(%w[get interaction]).each do |trigger|
            ::ClasslessMud::Lua.new(
              trigger.code,
              player,
              player.room,
              game
            ).run!
          end
        else
          player.puts "I don't see that anywhere"
        end
      end
    end
  end
end
