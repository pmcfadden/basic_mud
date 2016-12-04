module ClasslessMud
  module Commands
    class Quests
      def self.perform game, player, message
        _, quest_id = message.split ' '
        if quest_id && is_number?(quest_id)
          quest = player.quests.detect { |q| q.id == quest_id.to_i }
          if quest
            player.puts "Quest #{quest.name} (#{quest.id}):"
            player.puts quest.description
          else
            show_quests(player)
          end
        else
          show_quests(player)
        end
      end

      def self.is_number?(quest_id)
        quest_id =~ /^\d+$/
      end

      def self.show_quests(player)
        player.puts "Quests:"
        player.puts "  To show a specific quest, type quests <id>"
        player.campaigns.select { |c| !c.complete? }.each do |campaign|
          player.puts "  #{campaign.quest.id} - #{campaign.quest.name}"
        end
      end
    end
  end
end
