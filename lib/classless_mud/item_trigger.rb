# frozen_string_literal: true

module ClasslessMud
  class ItemTrigger
    include DataMapper::Resource

    property :id, Serial
    property :code, Text
    property :name, String
    property :type, String

    belongs_to :item
  end
end
