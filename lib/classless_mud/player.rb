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
      elsif message == 'quit'
        puts "Are you sure you want to quit? y/n: "
        @client.on do |response|
          if response == 'y' || response == 'Y'
            puts "Thanks for playing"
            room.exit self
            close_client
          end
        end
      elsif message == 'who'
        @game.display_players self
      elsif message == 'dance'
        puts 'Are you sure you want to dance? y/n: '
        @client.on do |dance_response|
          if dance_response == 'y' || dance_response == 'Y'
            puts 'Well, what kind of dancing? '
            @client.on do |kind_response|
              puts "You are a #{kind_response} dancing"
            end
          end
        end
      elsif message == 'character'
        character_sheet.display
      else
        move message
      end
    end

    def move direction
      valid_exit = self.room.exits.detect {|exit| exit.direction == direction}
      if valid_exit
        room.exit self
        valid_exit.target.enter self
      else
        puts "You can't go that way."
      end
    end

    def display_prompt
      puts_inline "#{name} > "
    end
  end
end
