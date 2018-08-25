module ClasslessMud
  class Dice
    def self.create(dice_type)
      rolls, sides, bonus = dice_type.split(/[d\+]/)
      new(sides.to_i, rolls.to_i, bonus.to_i)
    end

    attr_reader :sides
    attr_reader :rolls
    attr_reader :bonus

    def initialize(sides, rolls, bonus)
      @sides = sides
      @rolls = rolls
      @bonus = bonus
    end

    def roll
      (1..@rolls).map { roll_once }.inject(:+) + @bonus
    end

    private

    def roll_once
      Kernel.rand(@sides) + 1
    end
  end
end
