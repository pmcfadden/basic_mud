module ClasslessMud
  class Player
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    belongs_to :room

    attr_reader :name

    def self.accept client, name
      player = first(:name => name.chomp) || Player.create(:name => name.chomp)
      player.client= client
      player
    end

    def client= client
      @client = client
    end

    def handle_message message
      self.puts message
    end

    def gets
      @client.gets.chomp
    end

    def puts message
      @client.puts message
    end

    def close_client
      @client.close
    end

    def move direction
      valid_exit = self.room.exits.detect {|exit| exit.direction == direction}
      if valid_exit
        self.room.exit self
        valid_exit.target.enter self
      else
        self.puts "You can't go that way."
      end
    end
  end
end
