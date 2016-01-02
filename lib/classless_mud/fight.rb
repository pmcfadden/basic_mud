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
  end
end
