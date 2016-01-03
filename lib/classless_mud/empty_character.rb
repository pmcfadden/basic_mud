module ClasslessMud
  class EmptyCharacter
    include DataMapper::Resource
    include ClasslessMud::Character

    def initialize
      self.name = 'Unknown'
    end

    def puts message
      # Do nothing
    end

    def percent_health
      '0%'
    end
  end
end
