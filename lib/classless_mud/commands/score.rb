module ClasslessMud
  module Commands
    class Score
      extend ::ClasslessMud::Colorizer

      def self.perform(_game, player, _message)
        player.puts "You are level #{bright_yellow(player.level)}"
        player.puts "You have #{bright_green(player.health)} (#{green(player.max_health)}) hit points"
      end
    end
  end
end
