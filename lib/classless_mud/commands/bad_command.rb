module ClasslessMud
  module Commands
    class BadCommand
      def self.perform game, player, message
        # In here, we want to probably do some searching and be helpful.
        # Something like.. if message == looj, suggest look.
        player.puts 'You typed that wrong. Try again.'
      end
    end
  end
end
