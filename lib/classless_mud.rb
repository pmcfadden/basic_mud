require 'socket'

require "classless_mud/version"

class Game
  def initialize
    @players = []
  end

  def add_player player
    @players << player
    self.start_game_for player
  end

  def start_game_for player
    player.handle_message "game starting"
    loop do
      input = player.gets
      if input == 'quit'
        player.puts "Are you sure you want to quit? y/n: "
        response = player.gets
        player.puts response
        if response == 'y' || response == 'Y'
          player.puts "Thanks for playing"
          player.close_client
        end
      else
        player.handle_message input
      end
    end
  end
end

class Player
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

module ClasslessMud
  server = TCPServer.new 2000

  game = Game.new
  puts "Starting server on port 2000"
  loop do
    Thread.start(server.accept) do |client|
      client.puts "Enter name:"
      name = client.gets
      client.puts name
      player = Player.new client, name
      client.puts player
      game.add_player player
    end
  end
end
