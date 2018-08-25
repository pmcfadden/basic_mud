module ClasslessMud
  module Commands
    class Fight
      def self.perform(_game, player, message)
        target_name = message.split[1]
        target = player.room.characters.find { |c| c.name == target_name }
        if target.nil?
          player.puts "#{target_name} isn't here."
        else
          FightFactory.begin_fight(player, target)
          target.puts "#{player.name} has started a fight with you!"
          player.puts "You started a fight with #{target_name}!"
        end
      end
    end
  end
end
