module ClasslessMud
  class Item
    include DataMapper::Resource
    property :id, Serial
    property :type, Discriminator
    property :name, String
    property :short_description, String
    property :keywords, String

    def edible?
      false
    end
  end
end
