module ClasslessMud
  class Npc
    include DataMapper::Resource
    include ClasslessMud::Character
  end
end
