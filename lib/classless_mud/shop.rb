# frozen_string_literal: true

module ClasslessMud
  # Representation of a shop in the world
  class Shop
    include DataMapper::Resource

    property :id, Serial
    property :number, Integer, unique: true
    property :description, Text

    has n, :products
    has 1, :keeper, 'Npc'
  end
end
