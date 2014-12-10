module ClasslessMud
  class GameMaster
    def self.setup_player player
      player.health = player.max_health
    end
  end
end
