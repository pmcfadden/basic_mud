module ClasslessMud
  module Commands
    class Look
      def self.perform game, player, message
        look_command, look_target = message.split " ", 2
        if !look_target
          items = player.room.items.map do |item|
            item.short_description
          end.join(", ")

          player.puts player.room.description
          player.puts "You also see: #{items}"
        else
          found = player.room.find look_target
          if found
            player.puts found.short_description
          else
            player.puts "I don't see that anywhere"
          end
        end
      end
    end
  end
end
