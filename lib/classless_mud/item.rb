module ClasslessMud
  class Item
    include DataMapper::Resource
    property :id, Serial
    property :type, Discriminator
    property :name, String
    property :description, String
  end
end
