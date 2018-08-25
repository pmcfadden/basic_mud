module ClasslessMud
  module Commands
    class West
      def self.perform(game, player, _message)
        Move.perform game, player, 'west'
      end
    end
  end
end
