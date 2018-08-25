module ClasslessMud
  # Representation of something sold at a shop
  class Product
    include DataMapper::Resource

    property :quantity, Integer
    property :cost, Integer

    has 1, :item
  end
end
