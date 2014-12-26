module ClasslessMud
  # This module is included in both player
  # and NPC
  module Character
    extend ActiveSupport::Concern

    included do
      property :id, DataMapper::Property::Serial
      property :name, DataMapper::Property::String
      property :health, DataMapper::Property::Integer
      property :level, DataMapper::Property::Integer, default: 1

      has n, :items
      has 1, :character_sheet, default: CharacterSheet.new

      belongs_to :room
    end

    def game= game
      @game = game
    end

    def puts message
      @client.puts message
    end

    def puts_inline message
      @client.send_data message
    end

    def affect_health amount
      self.health += amount
      if amount > 0
        self.puts "You are healed for #{amount} health."
      else
        self.puts "You take #{amount.abs} damage."
      end
    end
  end
end
