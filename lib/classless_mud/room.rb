module ClasslessMud
  class Room
    include DataMapper::Resource
    property :id, Serial
    property :description, String
    has n, :players
    has n, :exits, :child_key => [ :source_id ]
    has n, :connected_rooms, self, :through => :exits, :via => :target
    has n, :items

    def enter player
      broadcast "#{player.name} entered the room"
      self.players << player
      player.puts description
    end

    def exit player
      self.players.delete player
      broadcast "#{player.name} left the room"
    end

    def broadcast message
      self.players.each do |occupant|
        occupant.puts message
      end
    end

    def broadcast_say from, message
      self.players.each do |player|
        if player == from
          player.puts "You say '#{message}'"
        else
          player.puts "#{from.name} says '#{message}'"
        end
      end
    end

    def handle_message message
      broadcast message
    end
  end
end
