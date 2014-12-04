module ClasslessMud
  class CharacterSheet
    include DataMapper::Resource
    property :id, Serial
    property :strength, Integer, default: 10
    property :agility, Integer, default: 10
    property :intelligence, Integer, default: 10

    belongs_to :player
  end
end
