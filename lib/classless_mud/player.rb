module ClasslessMud
  class Player
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :password, BCryptHash
    property :health, Integer
    property :level, Integer, default: 1

    has n, :items
    has 1, :character_sheet, default: CharacterSheet.new

    belongs_to :room

    attr_reader :name

    def client= client
      @client = client
    end

    def game= game
      @game = game
    end

    def puts message
      @client.puts message
    end

    def puts_inline message
      @client.send_data message
    end

    def close_client
      @game.remove_player self
      @client.close_connection
    end

    def on &callback
      @client.on &callback
    end

    def handle_message message
      if message.empty?
        # do nothing
      else
        Commands.parse(message).perform @game, self, message
      end
    end

    def display_prompt
      puts_inline "#{name} > "
    end

    def max_health
      10 * character_sheet.strength
    end

    def affect_health amount
      self.health += amount
      if amount > 0
        self.puts "You are healed for #{amount} health."
      else
        self.puts "You take #{amount.abs} damage."
      end
    end
  end
end
