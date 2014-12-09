module ClasslessMud
  class Player
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :password, BCryptHash
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
  end
end
