module ClasslessMud
  class RoomTrigger
    include DataMapper::Resource

    property :id, Serial
    property :code, Text
    property :name, String
    property :type, String

    belongs_to :room
  end
end
