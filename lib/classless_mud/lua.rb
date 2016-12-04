require 'rufus-lua'

module ClasslessMud
  class Lua
    def initialize(script, player, room, game)
      @script = script
      @player = player
      @room = room
      @game = game
    end

    def run!
      container = Rufus::Lua::State.new
      register_variables(container)
      register_functions(container)
      container.eval(@script)
      container.close
    end

    private

    def register_variables(container)
      container['current_room_id'] = @room.id
    end

    def register_functions(container)
      container.function 'quest_start' do |quest_id|
        quest = @game.find_quest(quest_id)
        if quest
          quest.start!(player)
        else
          @game.admin_log("Quest ##{quest_id} could not be found in lua game script.

                          #{caller.join("\n")}")
        end
      end

      container.function 'quest_complete' do |quest_id|
        quest = @game.find_quest(quest_id)
        if quest
          quest.complete!(player)
        else
          @game.admin_log("Quest ##{quest_id} could not be found in lua game script.

                          #{caller.join("\n")}")
        end
      end

      container.function 'ispc' do
        @player.player?
      end

      container.function 'goto' do |room_id|
        room = @game.world.find_room(room_id)
        if room
          @player.room.exit @player
          room.enter @player
        end
      end
    end
  end
end
