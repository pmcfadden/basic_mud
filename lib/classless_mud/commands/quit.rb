module ClasslessMud
  module Commands
    class Quit
      def self.perform(_game, player, _message)
        player.puts 'Are you sure you want to quit? y/n: '
        player.on do |response|
          if response == 'y' || response == 'Y'
            player.puts 'Thanks for playing'
            player.room.exit player
            player.close_client
            player.save!
          end
        end
      end
    end
  end
end
