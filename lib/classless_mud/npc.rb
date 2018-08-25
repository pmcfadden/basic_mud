module ClasslessMud
  # A "Non Player Character". This is an entity
  # in the game controlled by the game itself and
  # used to represent a person, monster, etc.
  class Npc
    include DataMapper::Resource
    include ClasslessMud::Character

    has n, :spawnpoints, child_key: [:npc_template_id]

    def puts(message); end

    def puts_inline(message); end

    def die
      @room.remove_npc self
    end

    attr_accessor :room

    def clone
      self.class.new(
        name: name,
        health: health,
        level: level
      )
    end
  end
end
