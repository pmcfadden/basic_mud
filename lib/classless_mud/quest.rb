module ClasslessMud
  class Quest
    include DataMapper::Resource

    property :id, Serial
    property :number, Integer, :unique => true
    property :description, Text
    property :name, String

    has n, :campaigns

    def victors
      campaigns.where(completed: true).players
    end

    def start!(player)
      existing_campaign = campaigns.detect { |c| c.players.include?(player) }
      if existing_campaign
        player.puts 'You have already started that quest!'
      else
        player.puts 'You have accepted a quest:'
        player.puts description
        campaigns.create(players: [player])
      end
    end

    def complete!(player)
      existing_campaign = campaigns.detect { |c| c.players.include?(player) }
      if existing_campaign
        if existing_campaign.complete?
          player.puts 'You have already completed that quest!'
        else
          player.puts 'Quest complete!'
          existing_campaign.update(completed: true)
        end
      else
        player.puts 'You have not started that quest yet.'
      end
    end
  end
end
