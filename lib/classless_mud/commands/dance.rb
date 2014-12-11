module ClasslessMud
  module Commands
    class Dance
      extend ClasslessMud::Colorizer

      def self.perform game, player, message
        player.puts red("Are you sure you want to dance? y/n: ")
        player.on do |dance_response|
          if dance_response == 'y' || dance_response == 'Y'
            player.puts 'Well, what kind of dancing? '
            player.on do |kind_response|
              player.puts "You are #{kind_response} dancing"
            end
          end
        end
      end
    end
  end
end

