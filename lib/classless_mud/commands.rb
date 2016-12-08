module ClasslessMud
  module Commands
    ALIASES_TO_COMMANDS_MAP = {
      'north' => North,
      'n' => North,
      'west' => West,
      'w' => West,
      'south' => South,
      's' => South,
      'east' => East,
      'e' => East,
      'kill' => Fight,
      'attack' => Fight
    }

    def self.parse data, player
      command = data.split[0]
      return ALIASES_TO_COMMANDS_MAP[command] if ALIASES_TO_COMMANDS_MAP.has_key?(command)
      all_commands(player).detect(-> { BadCommand }) do |c|
        c.name.demodulize.to_s.downcase == command
      end
    end

    def self.all_commands player
      regular_commands + (player.admin? ? admin_commands : [])
    end

    def self.regular_commands
      ClasslessMud::Commands.constants
        .select { |c| Class === ClasslessMud::Commands.const_get(c) }
        .map { |c| ClasslessMud::Commands.const_get(c) }
    end

    def self.admin_commands
      ClasslessMud::Commands::Admin.constants
        .select { |c| Class === ClasslessMud::Commands::Admin.const_get(c) }
        .map { |c| ClasslessMud::Commands::Admin.const_get(c) }
    end
  end
end
