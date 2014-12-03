module ClasslessMud
  class Exit
    include DataMapper::Resource
    property :id, Serial
    property :direction, String
    belongs_to :source, 'Room', :key => true
    belongs_to :target, 'Room', :key => true
  end
end
