module ClasslessMud
  class Player
    attr_reader :name

    def initialize client, name
      @client = client
      @name = name
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
  end
end
