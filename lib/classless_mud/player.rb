module ClasslessMud
  class Player
    include DataMapper::Resource
    include ClasslessMud::Character
    property :password, DataMapper::Property::BCryptHash

    def client= client
      @client = client
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

    def look
      handle_message "look"
    end

    def die
      self.puts "You dead. Respawning..."
      GameMaster.respawn_player self
    end

    def respawn_room
      @game.starting_room
    end
  end
end
