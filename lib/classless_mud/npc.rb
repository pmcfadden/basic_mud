module ClasslessMud
  class Npc
    include DataMapper::Resource
    include ClasslessMud::Character

    def puts message
    end

    def puts_inline message
    end

    def die
      room.remove_npc self
    end

    def room
      @room
    end

    def room= room
      @room = room
    end
  end
end
