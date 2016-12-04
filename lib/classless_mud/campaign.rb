module ClasslessMud
  class Campaign
    include DataMapper::Resource

    property :id, Serial
    property :completed, Boolean, default: false

    belongs_to :quest
    has n, :players, through: Resource

    def complete?
      completed
    end
  end
end
