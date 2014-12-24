module ClasslessMud
  class Effect
    include DataMapper::Resource
    property :id, Serial
    property :description, String
    property :health_modification, Integer, default: 0

    def affect player
      player.health = player.health + health_modification
      player.save!
      player.puts description
    end
  end
end
