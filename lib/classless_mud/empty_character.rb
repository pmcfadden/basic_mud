module ClasslessMud
  class EmptyCharacter
    attr_reader :name

    def initialize
      @name = 'Unknown'
    end

    def puts message
      # Do nothing
    end

    def percent_health
      '0%'
    end

    def damage_die
      '1d1+0'
    end

    def affect_health amount
      # Do nothing
    end

    def dead?
      true
    end

    def die
      # Do nothing
    end
  end
end
