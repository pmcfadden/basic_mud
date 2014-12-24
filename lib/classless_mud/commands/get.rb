module ClasslessMud
  module Commands
    class Get
      def self.perform game, player, message
        get_command, get_target = message.split " ", 2
        found = player.room.find get_target
        if found
          player.items << found
          player.room.items.delete found
          player.items.save!
          player.room.items.save!
          player.room.broadcast "#{player.name} picks up #{found.name}"
          player.puts "You pick up #{found.name}"
        else
          player.puts "I don't see that anywhere"
        end
      end
    end
  end
end
