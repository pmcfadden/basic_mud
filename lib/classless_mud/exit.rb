module ClasslessMud
  class Exit
    DIRECTIONS = ['north', 'south', 'east', 'west', 'up', 'down']
    include DataMapper::Resource
    property :id, Serial
    property :direction, String
    belongs_to :source, 'Room', :key => true
    belongs_to :target, 'Room', :key => true
    validates_with_method :direction, :method => :case_insensitive_direction_check

    def case_insensitive_direction_check
      DIRECTIONS.include? self.direction.downcase
    end
  end
end
