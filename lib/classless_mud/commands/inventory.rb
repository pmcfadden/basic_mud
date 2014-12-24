module ClasslessMud
  module Commands
    class Inventory
      def self.perform game, player, message
        player.puts "Inventory:"
        player.items.each do |item|
          player.puts "    #{item.name}"
        end
      end
    end
  end
end
