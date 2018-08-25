# frozen_string_literal: true

require 'socket'
require 'data_mapper'
require 'eventmachine'
require 'active_support'
require 'active_support/core_ext'
require 'fileutils'
require 'json'

require_relative 'classless_mud/version'
require_relative 'classless_mud/lua'
require_relative 'classless_mud/server'
require_relative 'classless_mud/client'
require_relative 'classless_mud/colorizer'
require_relative 'classless_mud/dice'
require_relative 'classless_mud/character_sheet'
require_relative 'classless_mud/item'
require_relative 'classless_mud/item_trigger'
require_relative 'classless_mud/character'
require_relative 'classless_mud/empty_character'
require_relative 'classless_mud/player'
require_relative 'classless_mud/quest'
require_relative 'classless_mud/campaign'
require_relative 'classless_mud/npc'
require_relative 'classless_mud/world'
require_relative 'classless_mud/game'
require_relative 'classless_mud/room'
require_relative 'classless_mud/room_trigger'
require_relative 'classless_mud/spawnpoint'
require_relative 'classless_mud/exit'
require_relative 'classless_mud/map'
require_relative 'classless_mud/account_builder'
require_relative 'classless_mud/character_sheet_builder'
require_relative 'classless_mud/game_master'
require_relative 'classless_mud/effect'
require_relative 'classless_mud/fight'
require_relative 'classless_mud/fight_commands'
require_relative 'classless_mud/fight_factory'
require_relative 'classless_mud/editor'
require_relative 'classless_mud/item_editor'
Dir[File.dirname(__FILE__) + '/classless_mud/commands/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/classless_mud/commands/admin/*.rb'].each { |f| require f }
require_relative 'classless_mud/commands'

module ClasslessMud
  def self.environment
    @environment || 'development'
  end

  def self.settings
    @settings ||= YAML.load_file('conf/settings.yml')
  end

  def self.db_url
    if ENV['DATABASE_URL']
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
    chocolate = Item.create name: 'Good Chocolate', short_description: 'a pristine bar of chocolate', keywords: 'pristine bar chocolate', edible: true
    chocolate.effects << plus_20
    bad_chocolate = Item.create name: 'Bad Chocolate', short_description: 'a sketchy bar of chocolate', keywords: 'sketchy bar chocolate', edible: true
    bad_chocolate.effects << minus_20

    chocolate.effects.save
    bad_chocolate.effects.save
    json_rooms = JSON.parse(File.read(File.join(conf_dir, 'rooms.json')))
    json_rooms.each do |json_room|
      Room.create(description: json_room['description'], number: json_room['number'])
    end
    json_rooms.each do |json_room|
      next unless json_room['exits']

      room = Room.first(number: json_room['number'])
      json_room['exits'].each do |ex|
        room.exits.create! direction: ex['direction'], target: Room.first(number: ex['room_number'])
      end
    end
    Player.create(name: 'Admin', health: 110, room_id: 1, level: 101, password: '$2a$10$wnIlkO2HwLX015kFppPpSeh/LM0ilttfXoyipkQwcy3yOTBgtJyhq') if Player.first(name: 'Admin').nil?
  end

  def self.setup_rooms!(rooms)
    rooms.each do |room|
      room.items << Item.first(name: 'Bad Chocolate')
      room.items << Item.first(name: 'Good Chocolate')
      goblin = Npc.new name: 'Goblin', health: 90, level: 2
      room.add_npc goblin
    end
  end

  def self.start!
    setup_db!

    rooms = Room.all
    # setup_rooms!(rooms)
    world = World.new rooms
    quests = Quest.all
    game = Game.new world, quests, settings

    EventMachine.run do
      puts "Starting server on port #{port}"
      ::ClasslessMud::Server.new(port, game).start
    end
  end

  def self.conf_dir
    File.join(Dir.pwd, 'conf')
  end

  def self.generate_scaffold
    FileUtils.mkdir_p(conf_dir)
    unless File.exist?(File.join(Dir.pwd, 'conf', 'settings.yml'))
      settings_template = File.join(File.dirname(File.expand_path(__FILE__)), 'classless_mud', 'templates', 'settings.yml.template')
      FileUtils.cp(settings_template, File.join(conf_dir, 'settings.yml'))
    end
    unless File.exist?(File.join(Dir.pwd, 'conf', 'rooms.json'))
      rooms_json = File.join(File.dirname(File.expand_path(__FILE__)), 'classless_mud', 'templates', 'rooms.json.template')
      FileUtils.cp(rooms_json, File.join(conf_dir, 'rooms.json'))
    end
  end
end
