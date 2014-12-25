module ClasslessMud
  class Effect
    include DataMapper::Resource
    property :id, Serial
    property :description, String
    property :health_modification, Integer, default: 0

    def affect player
      player.puts description
      player.affect_health health_modification
      player.save!
    end
  end
end
