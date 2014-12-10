module ClasslessMud
  module Commands
    class Score
      def self.perform game, player, message
        player.puts "You have #{player.health} (#{player.max_health}) hit points"
      end
    end
  end
end
