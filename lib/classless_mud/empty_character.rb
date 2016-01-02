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
  end
end
