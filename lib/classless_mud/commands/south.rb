module ClasslessMud
  module Commands
    class South
      def self.perform game, player, message
        Move.perform game, player, 'south'
      end
    end
  end
end
