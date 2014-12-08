module ClasslessMud
  module Commands
    COMMANDS_MAP = {
      'north' => Move,
      'west' => Move,
      'south' => Move,
      'east' => Move,
      'dance' => Dance,
      'who' => Who,
      'quit' => Quit,
      'character' => Character,
    }

    def self.parse data
      command = data.split[0]
      COMMANDS_MAP[command]
    end
  end
end
