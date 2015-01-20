module ClasslessMud
  class Npc
    include DataMapper::Resource
    include ClasslessMud::Character

    def puts message
    end

    def puts_inline message
    end
  end
end
