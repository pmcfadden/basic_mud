module ClasslessMud
  RACES = ['human', 'elven']
  class CharacterSheetBuilder
    attr_reader :player, :character_sheet, :on_complete

    def self.create player, &on_complete
      builder = self.new player, on_complete
      builder.build
      player.character_sheet
    end

    def initialize player, on_complete
      @player = player
      @character_sheet = CharacterSheet.new
      @on_complete = on_complete
    end

    def build
      player.puts <<EOS
We are going to roll your character. This means that your character
will be going through a process to determine its stats. Blah blah blah
instructions instructions.

First, you will need to select a race. The races available are:
  #{RACES.join(' ')}

Which race are you?
EOS
      player.on do |race|
        if RACES.include? race
          player.puts "Your character is now #{race}."
          character_sheet.race = race
          roll_stats
        else
          player.puts 'Invalid race.'
          build
        end
      end
    end

    def roll_stats
      strength_roll = two_d_six_die
      agility_roll = two_d_six_die
      intelligence_roll = two_d_six_die
      player.puts <<EOS
You rolled
  Strength    : #{strength_roll}
  Agility     : #{agility_roll}
  Intelligence: #{intelligence_roll}

Keep these? [y/N]
EOS

      player.on do |confirm_roll|
        if confirm_roll == 'Y' or confirm_roll == 'y'
          character_sheet.strength = strength_roll
          character_sheet.agility = agility_roll
          character_sheet.intelligence = intelligence_roll
          player.character_sheet = character_sheet
          player.save!
          @on_complete.call
        else
          roll_stats
        end
      end
    end

    def two_d_six_die
      (1..6).to_a.sample + (1..6).to_a.sample
    end
  end
end
