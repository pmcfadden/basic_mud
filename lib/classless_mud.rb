require 'socket'
require 'data_mapper'
require 'eventmachine'
require 'active_support'
require 'active_support/core_ext'

require_relative "classless_mud/version"
require_relative "classless_mud/server"
require_relative "classless_mud/client"
require_relative "classless_mud/colorizer"
require_relative "classless_mud/dice"
require_relative "classless_mud/character_sheet"
require_relative "classless_mud/item"
require_relative "classless_mud/character"
require_relative "classless_mud/empty_character"
require_relative "classless_mud/player"
require_relative "classless_mud/npc"
require_relative "classless_mud/world"
require_relative "classless_mud/game"
require_relative "classless_mud/room"
require_relative "classless_mud/exit"
require_relative "classless_mud/account_builder"
require_relative "classless_mud/character_sheet_builder"
require_relative "classless_mud/game_master"
require_relative "classless_mud/effect"
require_relative "classless_mud/fight"
require_relative "classless_mud/fight_commands"
require_relative "classless_mud/fight_factory"
Dir[File.dirname(__FILE__) + '/classless_mud/commands/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/classless_mud/commands/admin/*.rb'].each { |f| require f }
require_relative "classless_mud/commands"

module ClasslessMud
  def self.environment
    @environment || 'development'
  end

  def self.settings
    @settings ||= YAML.load_file('conf/settings.yml')
  end

  def self.db_url
    if ENV['RACK_ENV'] == 'production'
      ENV['DATABASE_URL']
    else
      "sqlite3://#{Dir.pwd}/#{settings['db']['name']}"
    end
  end

  def self.port
    ENV['PORT'] || 2000
  end

  def self.setup_db!
    DataMapper::Logger.new($stdout, :debug)
    puts "Using DB:#{db_url}"
    DataMapper.setup :default, db_url
    DataMapper.finalize
  end

  def self.setup_data!
    plus_20 = Effect.create description: 'You munch on the bar of chocolate and feel refreshed.', health_modification: 20
    minus_20 = Effect.create description: 'Despite better judgment, you bite into the open bar of chocolate. It is filled with razor blades.', health_modification: -20
    chocolate = Item.create name: "Good Chocolate", short_description: "a pristine bar of chocolate", keywords: "pristine bar chocolate", edible: true
    chocolate.effects << plus_20
    bad_chocolate = Item.create name: "Bad Chocolate", short_description: "a sketchy bar of chocolate", keywords: "sketchy bar chocolate", edible: true
    bad_chocolate.effects << minus_20

    chocolate.effects.save
    bad_chocolate.effects.save
    room1 = Room.create description: "There's a set of glass double doors to the west and an intersection of hallways to the east."
    room2 = Room.create description: "You are at an intersection of hallways.  Glass double doors lay to the north and south. An extension of the hallway lays to the west."
    room1.save!
    room2.save!
    room1.exits.create! direction: 'east', target: room2
    room2.exits.create! direction: 'west', target: room1
  end

  def self.setup_rooms! rooms
    rooms.each do |room|
      room.items << Item.first(:name => 'Bad Chocolate')
      room.items << Item.first(:name => 'Good Chocolate')
      goblin = Npc.new name: 'Goblin', health: 90, level: 2
      room.add_npc goblin
    end
  end

  def self.start!
    setup_db!

    rooms = Room.all
    setup_rooms!(rooms)
    world = World.new rooms
    game = Game.new world, settings

    EventMachine::run {
      puts "Starting server on port #{port}"
      ::ClasslessMud::Server.new(port, game).start
    }
  end
end
