module ClasslessMud
  module Commands
    class Who
      def self.perform(game, player, _message)
        game.display_players player
      end
    end
  end
end
