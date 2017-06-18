module ClasslessMud
  class CharacterSheet
    include ClasslessMud::Colorizer
    include DataMapper::Resource

    SHORT_FORM = {
      STR: :strength,
      AGI: :agility,
      INT: :intelligence,
      CON: :constitution,
      WIS: :wisdom,
      CHA: :charisma
    }

    property :id, Serial
    property :strength, Integer, default: 10
    property :agility, Integer, default: 10
    property :intelligence, Integer, default: 10
    property :constitution, Integer, default: 10
    property :wisdom, Integer, default: 10
    property :charisma, Integer, default: 10
    property :race, String, default: 'human'
    property :profession, String, default: 'fighter'

    belongs_to :player

    def display
      player.puts <<EOS
#{green(player.name)} - #{red(race)}

#{green('Strength')}:     #{red(strength)}
#{green('Agility')}:      #{red(agility)}
#{green('Intelligence')}: #{red(intelligence)}

#{green('Superpowers')}: #{red('none')}
EOS
    end
  end
end
