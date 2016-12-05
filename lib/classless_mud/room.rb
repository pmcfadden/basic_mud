module ClasslessMud
  class Room
    include DataMapper::Resource
    property :id, Serial
    property :number, Integer, :unique => true
    property :description, Text

    has n, :exits, :child_key => [ :source_id ]
    has n, :connected_rooms, self, :through => :exits, :via => :target
    has n, :triggers, 'RoomTrigger', child_key: 'room_id'

    def items
      @items = @items || []
      @items
    end

    def triggers_for(types)
      triggers.select { |trigger| types.include?(trigger.type) }
    end

    def players
      @players = @players || []
      @players
    end

    def npcs
      @npcs = @npcs || []
      @npcs
    end

    def enter player, message="#{player.name} entered the room."
      player.room = self
      broadcast message
      players << player
      player.save
      player.look
    end

    def add_npc npc
      npc.room = self
      npcs << npc
    end

    def remove_npc npc
      npc.room = nil
      npcs.delete(npc)
    end

    def characters
      npcs.to_a + players.to_a
    end

    def exit player
      players.delete player
      broadcast "#{player.name} left the room"
      save
    end

    def broadcast message
      players.each do |occupant|
        occupant.puts message
      end
    end

    def broadcast_say from, message
      players.each do |player|
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

    def find keywords
      keywords_array = keywords.split
      items.detect do |item|
        (item.keywords.split & keywords_array).any?
      end
    end

    def find_character keyword
      characters.detect do |character|
        character.name.include? keyword
      end
    end

    def find_exit direction
      exits.first(direction: direction)
    end
  end
end
