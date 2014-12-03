module ClasslessMud
  class Exit
    include DataMapper::Resource
    property :id, Serial
    belongs_to :source, 'Room', :key => true
    belongs_to :target, 'Room', :key => true
  end
end
