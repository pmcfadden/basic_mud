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
      damage_by_one = Dice.create('3d4+0').roll
      damage_by_two = Dice.create('3d4+0').roll
      @two.puts "You do #{damage_by_two} damage to #{@one.name}."
      @one.puts "You do #{damage_by_one} damage to #{@two.name}."
      @two.affect_health damage_by_one * -1
      @one.affect_health damage_by_two * -1
      if @one.dead?
        @one.die
        @two.puts "You killed #{@one.name}."
        @two.end_fight!
      end
      if @two.dead?
        @two.die
        @one.puts "You killed #{@two.name}."
        @one.end_fight!
      end
    end
  end
end
