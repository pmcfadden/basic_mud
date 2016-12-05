module ClasslessMud
  class Npc
    include DataMapper::Resource
    include ClasslessMud::Character

    has n, :spawnpoints, child_key: [:npc_template_id]

    def puts message
    end

    def puts_inline message
    end

    def die
      @room.remove_npc self
    end

    def room
      @room
    end

    def room= room
      @room = room
    end

    def clone
      self.class.new(
        name: name,
        health: health,
        level: level
      )
    end
  end
end
