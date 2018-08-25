# frozen_string_literal: true

module ClasslessMud
  module Commands
    class Map
      def self.perform(_game, player, _message)
        player.puts 'Map with distance 5:'
        player.puts ::ClasslessMud::Map.new(player.room).print_map
      end
    end
  end
end
