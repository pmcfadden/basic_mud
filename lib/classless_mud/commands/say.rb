module ClasslessMud
  module Commands
    class Say
      def self.perform game, player, message
        say_command, say_message = message.split(' ', 2)
        player.room.broadcast_say player, say_message
      end
    end
  end
end
