module ClasslessMud
  class Npc
    include DataMapper::Resource
    include ClasslessMud::Character

    def puts message
    end

    def puts_inline message
    end

    def die
      self.save!
    end
  end
end
