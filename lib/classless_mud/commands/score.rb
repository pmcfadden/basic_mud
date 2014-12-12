module ClasslessMud
  module Commands
    class Score
      extend ::ClasslessMud::Colorizer

      def self.perform game, player, message
        player.puts "You have #{bright_green(player.health)} (#{green(player.max_health)}) hit points"
      end
    end
  end
end
