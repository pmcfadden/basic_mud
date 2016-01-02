module ClasslessMud
  class Fight
    def initialize(character_one, character_two)
      @one = character_one
      @two = character_two
    end

    def title
      "Fight between #{@one.name} and #{@two.name}"
    end

    def other(character)
      if character == @one
        @two
      else
        @one
      end
    end

    def attack!
      damage_by_one = Dice.create('1d4+0').roll * -1
      damage_by_two = Dice.create('1d4+0').roll * -1
      @two.affect_health damage_by_one
      @one.affect_health damage_by_two
    end
  end
end
