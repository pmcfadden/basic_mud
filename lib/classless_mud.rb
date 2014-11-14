require 'socket'

require "classless_mud/version"

class Game
  def initialize player
    @player = player
  end

  def start
    @player.handle_message "game starting"
  end
end

class Player
  def initialize client, name
    @client = client
    @name = name
  end

  def handle_message message
    @client.puts message
  end
end

module ClasslessMud
  server = TCPServer.new 2000

  puts "Starting server on port 2000"
  loop do
    Thread.start(server.accept) do |client|
      client.puts "Enter name:"
      name = client.gets
      client.puts name
      player = Player.new client, name
      client.puts player
      game = Game.new player
      client.puts game
      game.start
    end
  end
end
