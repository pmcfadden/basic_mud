require 'socket'

require_relative "classless_mud/version"
require_relative "classless_mud/player.rb"
require_relative "classless_mud/world.rb"
require_relative "classless_mud/game.rb"
require_relative "classless_mud/room.rb"
require_relative "classless_mud/input_parser.rb"

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
