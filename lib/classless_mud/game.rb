# frozen_string_literal: true

module ClasslessMud
  class Game
    attr_reader :players
    attr_reader :settings
    attr_reader :world

    def initialize(world, quests, settings)
      @players = []
      @world = world
      @settings = settings
      @quests = quests
    end

    def tick
      @world.tick
    end

    def find_quest(quest_id)
      @quests.detect { |q| q.id == quest_id }
    end

    def add_quest(quest)
      @quests << quest
    end

    def max_quest_number
      @quests.map(&:number).max || 0
    end

    def admin_log(message)
      @players.select(&:admin?).each do |admin|
        admin.puts message
      end
    end

    def add_player(player)
      @players << player
      player_room = player.room
      if player_room
        player_room.enter player
      else
        starting_room.enter player
      end
      broadcast "#{player.name} has joined the game."
    end

    def starting_room
      @world.starting_room
    end

    def room_with_number(number)
      @world.find_room_by_number number
    end

    def remove_player(player)
      player.room&.exit player
      @players.delete player
      broadcast "#{player.name} has left the game."
    end

    def broadcast(message)
      @world.handle_message message
    end

    def display_players(player)
      player.puts <<~EOS
        Currently active players
        ------------------------
        #{@players.map(&:name).join("\n")}
EOS
    end
  end
end
