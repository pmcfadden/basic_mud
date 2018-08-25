module ClasslessMud
  RACES = %w[human elven halfling giant].freeze
  PROFESSIONS = %w[bard cleric fighter paladin ranger thief wizard].freeze
  class CharacterSheetBuilder
    attr_reader :player, :character_sheet, :on_complete

    def self.create(player, &on_complete)
      builder = new player, on_complete
      builder.build
      player.character_sheet
    end

    def initialize(player, on_complete)
      @player = player
      @character_sheet = CharacterSheet.new
      @on_complete = on_complete
    end

    def build
      player.puts <<EOS
We are going to roll your character. This means that your character
will be going through a process to determine its stats. Blah blah blah
instructions instructions.

First, you will need to select a profession. The professions available are:
  #{PROFESSIONS.join(' ')}

Which class are you?
EOS
      player.on do |profession|
        if PROFESSIONS.include? profession
          player.puts "Your character is now a #{profession}."
          character_sheet.profession = profession
          choose_race
        else
          player.puts 'Invalid profession.'
          build
        end
      end
    end

    def choose_race
      player.puts <<EOS
Now you need to select your race. The races available are:
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
          choose_race
        end
      end
    end

    def roll_stats
      strength_roll, agility_roll, intelligence_roll,
        constitution_roll, wisdom_roll, charisma_roll = (1..6).map { Dice.create('2d6+0').roll }
      player.puts <<EOS
You rolled
  Strength    : #{strength_roll}
  Agility     : #{agility_roll}
  Intelligence: #{intelligence_roll}
  Constitution: #{constitution_roll}
  Wisdom      : #{wisdom_roll}
  Charisma    : #{charisma_roll}

Keep these? [y/N]
EOS

      player.on do |confirm_roll|
        if confirm_roll == 'Y' || confirm_roll == 'y'
          character_sheet.strength = strength_roll
          character_sheet.agility = agility_roll
          character_sheet.intelligence = intelligence_roll
          character_sheet.constitution = constitution_roll
          character_sheet.wisdom = wisdom_roll
          character_sheet.charisma = charisma_roll
          player.character_sheet = character_sheet
          player.save!
          @on_complete.call
        else
          roll_stats
        end
      end
    end
  end
end
