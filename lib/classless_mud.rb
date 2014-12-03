require 'socket'
require 'data_mapper'

require_relative "classless_mud/version"
require_relative "classless_mud/player.rb"
require_relative "classless_mud/world.rb"
require_relative "classless_mud/game.rb"
require_relative "classless_mud/room.rb"
require_relative "classless_mud/exit.rb"
require_relative "classless_mud/input_parser.rb"

module ClasslessMud
  def self.start!
    DataMapper::Logger.new($stdout, :debug)
    db_name = YAML.load_file('conf/settings.yml')['db']['name']
    puts "Using DB:#{db_name}"
    DataMapper.setup :default, "sqlite3://#{Dir.pwd}/#{db_name}"
    DataMapper.finalize

    server = TCPServer.new 2000

    room1 = Room.create! description: "You exit an elevator and glance around.  There's a set of glass double doors to the west and an intersection of hallways to the east"
    room2 = Room.create! description: "You are at an intersection of hallways.  Glass double doors lay to the north and south. An extension of the hallway lays to the west"
    room1.exits.create! direction: 'east', target: room2
    room2.exits.create! direction: 'west', target: room1
    world = World.new [room1, room2]
    game = Game.new world
    puts "Starting server on port 2000"
    loop do
      Thread.start(server.accept) do |client|
        client.puts "Enter name:"
        name = client.gets
        player = Player.accept client, name
        game.add_player player
      end
    end

  end


end
