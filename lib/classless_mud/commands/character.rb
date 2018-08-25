# frozen_string_literal: true

module ClasslessMud
  module Commands
    class Character
      def self.perform(_game, player, _message)
        player.character_sheet.display
      end
    end
  end
end
