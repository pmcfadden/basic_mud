require 'socket'

require_relative "./game.rb"
require_relative "./player.rb"
require "classless_mud/version"

module ClasslessMud
  server = TCPServer.new 2000

  game = Game.new
  puts "Starting server on port 2000"
  loop do
    Thread.start(server.accept) do |client|
      client.puts "Enter name:"
      name = client.gets
      player = Player.new client, name
      game.add_player player
    end
  end
end
