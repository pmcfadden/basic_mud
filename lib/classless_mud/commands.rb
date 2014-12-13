module ClasslessMud
  module Commands
    ALIASES_TO_COMMANDS_MAP = {
      'north' => Move,
      'west' => Move,
      'south' => Move,
      'east' => Move
    }

    def self.parse data
      command = data.split[0]
      return ALIASES_TO_COMMANDS_MAP[command] if ALIASES_TO_COMMANDS_MAP.has_key?(command)
      all_commands.detect(-> { BadCommand }) { |c| c.name.demodulize.to_s.downcase == command }
    end

    def self.all_commands
      regular_commands + admin_commands
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
