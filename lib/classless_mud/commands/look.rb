module ClasslessMud
  module Commands
    class Look
      def self.perform game, player, message
        _, look_target = message.split " ", 2
        if !look_target
          look_around player
        else
          look_at player, look_target
        end
      end

      def self.look_around player
        map = ::ClasslessMud::Map.new(player.room)
        player.puts map_and_description(player.room.description, map)

        if player.room.items.any?
          items = player.room.items.map do |item|
            item.short_description
          end.join(", ")

          player.puts "You also see: #{items}"
        end

        if player.room.exits.any?
          player.puts "Exits: #{player.room.exits.map(&:direction).join(' ')}"
        end

        if player.room.characters.any?
          characters = player.room.characters.map do |character|
            character.name
          end.join(", ")

          player.puts "Here: #{characters}"
        end
      end

      def self.look_at player, look_target
        found = player.room.find look_target
        if found
          player.puts found.short_description
        else
          player.puts "I don't see that anywhere"
        end
      end

      def self.map_and_description(description, map)
        map_text = map.print_map(1).split("\n")
        longest_line = description.split("\n").map(&:size).max + 4
        padded_description = description.split("\n")
        padded_description += [""] * ([map_text.size - padded_description.size, 0].max)
        padded_description.each_with_index.map do |description_line, i|
          spaces = " " * (longest_line - description_line.size)
          "#{description_line}#{spaces}#{map_text[i]}"
        end.join("\n")
      end
    end
  end
end
