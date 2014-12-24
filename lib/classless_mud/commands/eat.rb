module ClasslessMud
  module Commands
    class Eat
      def self.perform game, player, message
        command, target = message.split " ", 2
        found = item_from player, target
        if found.nil?
          player.puts "You do not have that"
        else
          if found.edible?
            found.affect(player)
            player.items.delete found
            player.items.save!
            player.puts "You eat #{found.name}."
          else
            player.puts "You cannot eat that!"
          end
        end
      end

      def self.item_from player, target
        player.items.detect { |item| (item.keywords.split & target.split).any? }
      end
    end
  end
end
