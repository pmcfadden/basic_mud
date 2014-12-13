module ClasslessMud::Commands::Admin
  class Kick
    def self.perform game, player, message
      other_player_name = message.split[1]
      other_player = game.players.find { |player| player.name == other_player_name }
      if other_player.nil?
        player.puts "#{other_player_name} isn't here."
      else
        other_player.puts 'You are being kicked. Have a nice day!'
        other_player.close_client
        player.puts "You kicked #{other_player_name}."
      end
    end
  end
end
