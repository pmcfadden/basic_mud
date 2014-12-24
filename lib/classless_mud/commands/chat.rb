module ClasslessMud
  module Commands
    class Chat
      extend ::ClasslessMud::Colorizer

      def self.perform game, player, message
        command, message = message.split(' ', 2)
        game.players.each do |player|
          player.puts red("[CHAT] #{player.name}: #{message}")
        end
      end
    end
  end
end
