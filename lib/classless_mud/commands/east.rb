module ClasslessMud
  module Commands
    class East
      def self.perform game, player, message
        Move.perform game, player, 'east'
      end
    end
  end
end
