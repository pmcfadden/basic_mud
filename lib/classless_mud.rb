require 'socket'

require "classless_mud/version"

class Game
  def initialize client, player
    @client = client
    @player = player
  end

  def start
    @client.puts "game starting"
  end
end

class Player
  def initialize name
    @name = name
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
      player = Player.new name
      client.puts player
      game = Game.new client, player
      client.puts game
      game.start
    end
  end
end
