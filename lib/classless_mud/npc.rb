module ClasslessMud
  class NPC
    include DataMapper::Resource
    include ClasslessMud::Character
  end
end
