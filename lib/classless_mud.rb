require 'socket'
require 'data_mapper'

require_relative "classless_mud/version"
require_relative "classless_mud/player.rb"
require_relative "classless_mud/world.rb"
require_relative "classless_mud/game.rb"
require_relative "classless_mud/room.rb"
require_relative "classless_mud/input_parser.rb"

module ClasslessMud
  def self.start!
    DataMapper::Logger.new($stdout, :debug)
    db_name = YAML.load_file('conf/settings.yml')['db']['name']
    puts "Using DB:#{db_name}"
    DataMapper.setup :default, "sqlite3://#{Dir.pwd}/#{db_name}"
    DataMapper.finalize

    server = TCPServer.new 2000

    game = Game.new
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
