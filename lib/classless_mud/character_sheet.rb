module ClasslessMud
  class CharacterSheet
    include DataMapper::Resource
    property :id, Serial
    property :strength, Integer, default: 10
    property :agility, Integer, default: 10
    property :intelligence, Integer, default: 10
    property :race, String, default: 'human'

    belongs_to :player

    def display
      player.puts <<EOS
#{player.name} - #{race}

Strength:     #{strength}
Agility:      #{agility}
Intelligence: #{intelligence}

Superpowers: none
EOS
    end
  end
end
