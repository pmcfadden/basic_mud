module ClasslessMud
  # This module is included in both player
  # and NPC
  module Character
    extend ActiveSupport::Concern

    FIGHT = 'fight'
    NORMAL = 'normal'

    included do
      property :id, DataMapper::Property::Serial
      property :name, DataMapper::Property::String
      property :health, DataMapper::Property::Integer
      property :level, DataMapper::Property::Integer, default: 1
      property :state, DataMapper::Property::String, default: NORMAL

      has n, :items
      has 1, :character_sheet, default: CharacterSheet.new, child_key: :player_id

      belongs_to :room
    end

    def game= game
      @game = game
    end

    def affect_health amount
      self.health += amount
      if amount > 0
        self.puts "You are healed for #{amount} health."
        self.puts "You have #{health} health"
      else
        self.puts "You take #{amount.abs} damage."
        self.puts "You have #{health} health"
        die if dead?
      end
    end

    def fight!
      self.state = FIGHT
    end

    def dead?
      health <= 0
    end
  end
end
