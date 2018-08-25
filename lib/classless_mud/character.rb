module ClasslessMud
  # This module is included in both player
  # and NPC
  module Character
    extend ActiveSupport::Concern
    include ClasslessMud::Colorizer

    FIGHT = 'fight'.freeze
    EDITOR = 'editor'.freeze
    NORMAL = 'normal'.freeze

    included do
      property :id, DataMapper::Property::Serial
      property :name, DataMapper::Property::String
      property :health, DataMapper::Property::Integer
      property :level, DataMapper::Property::Integer, default: 1
      property :state, DataMapper::Property::String, default: NORMAL

      has n, :items
      has 1, :character_sheet, default: CharacterSheet.new, child_key: :player_id

      belongs_to :room, required: false
    end

    def reset!
      self.state = NORMAL
      save
    end

    def game=(game)
      @game = game
    end

    def damage_die
      "1d4+#{character_sheet.strength || 0}"
    end

    def current_fight
      @current_fight || Fight.new(self, EmptyCharacter.new)
    end

    def current_editor
      @current_editor || Editor.new(self)
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

    def affect_health(amount)
      self.health += amount
      if amount > 0
        puts "You are healed for #{amount} health."
        puts "You have #{health} health"
      else
        puts "You take #{amount.abs} damage."
        puts "You have #{health} health"
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

    def editor!(editor)
      self.state = EDITOR
      @current_editor = editor
    end

    def end_editor!
      self.state = NORMAL
    end

    def dead?
      health <= 0
    end

    def room
      @game.world.find_room(room_id)
    end

    def player?
      false
    end

    def find_in_inventory(keywords)
      keywords_array = keywords.split
      items.detect do |item|
        (item.keywords.split & keywords_array).any?
      end
    end
  end
end
