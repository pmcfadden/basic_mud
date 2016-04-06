module ClasslessMud
  class Effect
    include DataMapper::Resource
    property :id, Serial
    property :description, String, :length => 255
    property :health_modification, Integer, default: 0
    belongs_to :item, :required => false

    def affect player
      player.puts description
      player.affect_health health_modification
      player.save!
    end
  end
end
