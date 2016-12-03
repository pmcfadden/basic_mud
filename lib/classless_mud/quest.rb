module ClasslessMud
  class Quest
    include DataMapper::Resource

    property :id, Serial
    property :number, Integer, :unique => true
    property :description, Text

    has n, :campaigns

    def victors
      campaigns.where(completed: true).players
    end
  end
end
