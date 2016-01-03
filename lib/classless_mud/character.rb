module ClasslessMud
  # This module is included in both player
  # and NPC
  module Character
    extend ActiveSupport::Concern
    include ClasslessMud::Colorizer

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

    def current_fight
      @current_fight || Fight.new(self, EmptyCharacter.new)
    end

    def max_health
      10 * character_sheet.strength
    end

    def percent_health
      percent = ((health.to_d / max_health.to_d) * 100).to_i
      if percent > 80
        green("#{percent}%")
      elsif percent > 40
        yellow("#{percent}%")
      else
        red("#{percent}%")
      end
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

    def fight!(fight)
      self.state = FIGHT
      @current_fight = fight
    end

    def end_fight!
      self.state = NORMAL
      @current_fight = nil
    end

    def dead?
      health <= 0
    end
  end
end
