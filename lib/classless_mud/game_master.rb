# frozen_string_literal: true

module ClasslessMud
  class GameMaster
    def self.setup_player(player)
      player.health = player.max_health
    end

    def self.respawn_player(player)
      player.health = player.max_health
      player.room.exit player
      player.respawn_room.enter player
    end
  end
end
