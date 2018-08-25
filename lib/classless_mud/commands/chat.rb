# frozen_string_literal: true

module ClasslessMud
  module Commands
    class Chat
      extend ::ClasslessMud::Colorizer

      def self.perform(game, _player, message)
        command, message = message.split(' ', 2)
        game.players.each do |player|
          player.puts red("[CHAT] #{player.name}: #{message}")
        end
      end
    end
  end
end
