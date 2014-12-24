module ClasslessMud
  class Item
    include DataMapper::Resource
    property :id, Serial
    property :type, Discriminator
    property :name, String
    property :short_description, String
    property :keywords, String
    property :edible, Boolean, default: false
    property :health_effect, Integer, default: 0
    property :effect_description, String, default: ''

    def edible?
      edible
    end
  end
end
