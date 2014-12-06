module ClasslessMud
  module Commands
    class Character
      def self.perform game, player, message
        player.character_sheet.display
      end
    end
  end
end
