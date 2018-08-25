# frozen_string_literal: true

module ClasslessMud
  module Commands
    class Inventory
      def self.perform(_game, player, _message)
        player.puts 'Inventory:'
        player.items.each do |item|
          player.puts "    #{item.name}"
        end
      end
    end
  end
end
