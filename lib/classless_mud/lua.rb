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
