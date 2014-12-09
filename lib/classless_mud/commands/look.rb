module ClasslessMud
  module Commands
    class Look
      def self.perform game, player, message
        player.puts player.room.description
      end
    end
  end
end
