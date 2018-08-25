# frozen_string_literal: true

module ClasslessMud
  class FightFactory
    def self.begin_fight(character_one, character_two)
      fight = Fight.new(character_one, character_two)
      character_one.fight! fight
      character_two.fight! fight
      character_one.save!
      character_two.save!
      fight
    end
  end
end
