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
      "classless_mud/commands/#{command}".camelize.constantize
    rescue NameError => e
      BadCommand
    end
  end
end
