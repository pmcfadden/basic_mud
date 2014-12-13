require 'socket'
require 'data_mapper'
require 'eventmachine'
require 'active_support'
require 'active_support/core_ext'

require_relative "classless_mud/version"
require_relative "classless_mud/server"
require_relative "classless_mud/client"
require_relative "classless_mud/colorizer"
require_relative "classless_mud/character_sheet"
require_relative "classless_mud/player"
require_relative "classless_mud/world"
require_relative "classless_mud/game"
require_relative "classless_mud/room"
require_relative "classless_mud/exit"
require_relative "classless_mud/account_builder"
require_relative "classless_mud/character_sheet_builder"
require_relative "classless_mud/game_master"
Dir[File.dirname(__FILE__) + '/classless_mud/commands/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/classless_mud/commands/admin/*.rb'].each { |f| require f }
require_relative "classless_mud/commands"

module ClasslessMud
  def self.settings
    @settings ||= YAML.load_file('conf/settings.yml')
  end

  def self.setup_db!
    DataMapper::Logger.new($stdout, :debug)
    db_name = settings['db']['name']
    puts "Using DB:#{db_name}"
    DataMapper.setup :default, "sqlite3://#{Dir.pwd}/#{db_name}"
    DataMapper.finalize
  end

  def self.start!
    setup_db!

    room1 = Room.create! description: "You exit an elevator and glance around.  There's a set of glass double doors to the west and an intersection of hallways to the east"
    room2 = Room.create! description: "You are at an intersection of hallways.  Glass double doors lay to the north and south. An extension of the hallway lays to the west"
    room1.exits.create! direction: 'east', target: room2
    room2.exits.create! direction: 'west', target: room1
    world = World.new [room1, room2]
    game = Game.new world, settings

    EventMachine::run {
      puts "Starting server on port 2000"
      ::ClasslessMud::Server.new(2000, game).start
    }
  end
end
