module ClasslessMud
  RACES = ['human', 'elf']
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
          roll_stats
        else
          player.puts 'Invalid race.'
          build
        end
      end
    end

    def roll_stats
      @on_complete.call
    end
  end
end
