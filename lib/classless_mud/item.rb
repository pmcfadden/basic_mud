module ClasslessMud
  class Item
    include DataMapper::Resource
    property :id, Serial
    property :type, Discriminator
    property :name, String
    property :short_description, String
    property :keywords, String
    property :edible, Boolean, default: false

    has n, :effects
    has n, :triggers, 'ItemTrigger', child_key: 'item_id'

    belongs_to :player, :required => false
    belongs_to :npc, :required => false

    def edible?
      edible
    end

    def affect player
      effects.each { |effect| effect.affect(player) }
    end
  end
end
