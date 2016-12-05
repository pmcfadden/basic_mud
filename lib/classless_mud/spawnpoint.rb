module ClasslessMud
  class Spawnpoint
    include DataMapper::Resource

    property :id, Serial
    property :max_alive, Integer
    property :time_interval, Integer
    property :last_spawn, DateTime

    has n, :npcs, through: Resource
    belongs_to :npc_template, 'Npc'
    belongs_to :room

    def try_spawn!
      if should_spawn?
        new_npc = npc_template.clone!
        new_npc.room = room
        room.characters << new_npc
        new_npc.save
      end
    end

    private

    def alive_npcs
      npcs.select { |npc| !npc.dead? }
    end

    def should_spawn?
      last_spawn > Time.now - time_interval.seconds && alive_npcs.size < max_alive
    end
  end
end
