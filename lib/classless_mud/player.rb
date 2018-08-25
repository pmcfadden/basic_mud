# frozen_string_literal: true

module ClasslessMud
  class Player
    include DataMapper::Resource
    include ClasslessMud::Character

    ADMIN_LEVEL = 101

    property :password, DataMapper::Property::BCryptHash

    has n, :campaigns, through: Resource

    def admin?
      level >= ADMIN_LEVEL
    end

    def quests
      campaigns.map(&:quest)
    end

    attr_writer :client

    def close_client
      @game.remove_player self
      @client.close_connection
    end

    def on(&callback)
      @client.on(&callback)
    end

    def puts(message)
      @client.puts message
    end

    def puts_inline(message)
      @client.send_data message
    end

    def handle_message(message)
      case state
      when Character::FIGHT
        FightCommands.parse(message).perform @game, self, current_fight, message
      when Character::EDITOR
        current_editor.handle(message)
      else
        if message.empty?
          # do nothing
        else
          Commands.parse(message, self).perform @game, self, message
        end
      end
    end

    def display_prompt
      puts_inline "#{name} #{fighting_prompt}> "
    end

    def fighting_prompt
      if state == Character::FIGHT
        percent_health = current_fight.other(self).percent_health
        "(#{red('Fighting')} - #{percent_health}) "
      else
        ''
      end
    end

    def look
      handle_message 'look'
    end

    def die
      puts 'You dead. Respawning...'
      self.state = NORMAL
      GameMaster.respawn_player self
    end

    def respawn_room
      @game.starting_room
    end

    def player?
      true
    end
  end
end
