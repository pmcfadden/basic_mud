require 'socket'
require 'data_mapper'
require 'eventmachine'

require_relative "classless_mud/version"
require_relative "classless_mud/player.rb"
require_relative "classless_mud/world.rb"
require_relative "classless_mud/game.rb"
require_relative "classless_mud/room.rb"
require_relative "classless_mud/exit.rb"
require_relative "classless_mud/input_parser.rb"

module ClasslessMud
  class Server
    attr_reader :game

    def initialize port, game
      @port = port
      @game = game
    end

    def start
      @signature = EventMachine.start_server('0.0.0.0', @port, ::ClasslessMud::Client) do |con|
        con.game = game
      end
    end

    def stop
      EventMachine.stop_server(@signature)
    end
  end

  class Client < EventMachine::Connection
    attr_accessor :game
    attr_reader :player

    def initialize
      @logged_in = false
    end

    def post_init
      send_data "Enter name:"
    end

    def receive_data data
      data = data.chomp
      return login(data) unless @logged_in
      if @callback
        @callback.call(data)
        @callback = nil
        return
      end
      player.handle_message data
    end

    def on &callback
      @callback = callback
    end

    def login name
      @logged_in = true
      @player = Player.accept self, name
      game.add_player player
    end

    def puts message
      send_data "#{message}\n"
    end
  end

  def self.start!
    DataMapper::Logger.new($stdout, :debug)
    db_name = YAML.load_file('conf/settings.yml')['db']['name']
    puts "Using DB:#{db_name}"
    DataMapper.setup :default, "sqlite3://#{Dir.pwd}/#{db_name}"
    DataMapper.finalize

    room1 = Room.create! description: "You exit an elevator and glance around.  There's a set of glass double doors to the west and an intersection of hallways to the east"
    room2 = Room.create! description: "You are at an intersection of hallways.  Glass double doors lay to the north and south. An extension of the hallway lays to the west"
    room1.exits.create! direction: 'east', target: room2
    room2.exits.create! direction: 'west', target: room1
    world = World.new [room1, room2]
    game = Game.new world

    EventMachine::run {
      puts "Starting server on port 2000"
      ::ClasslessMud::Server.new(2000, game).start
    }
  end
end
