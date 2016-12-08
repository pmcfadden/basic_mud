module ClasslessMud
  module Commands
    class North
      def self.perform game, player, message
        Move.perform game, player, 'north'
      end
    end
  end
end
